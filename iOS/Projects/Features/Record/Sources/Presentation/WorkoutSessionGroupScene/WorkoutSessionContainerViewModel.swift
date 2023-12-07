//
//  WorkoutSessionContainerViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineExtension
import CoreLocation
import Foundation
import Log

// MARK: - WorkoutSessionViewModelDependency

protocol WorkoutSessionViewModelDependency {
  var startDate: Date { get }
}

// MARK: - WorkoutSessionContainerViewModelInput

public struct WorkoutSessionContainerViewModelInput {
  let endWorkoutPublisher: AnyPublisher<Void, Never>
  let locationPublisher: AnyPublisher<[CLLocation], Never>
  let mapCaptureImageDataPublisher: AnyPublisher<Data?, Never>
  let healthPublisher: AnyPublisher<WorkoutHealthForm, Never>
}

public typealias WorkoutSessionContainerViewModelOutput = AnyPublisher<WorkoutSessionContainerState, Never>

// MARK: - WorkoutSessionContainerState

public enum WorkoutSessionContainerState {
  case idle
  case updateTime(Int)
  case alert(Error)
}

// MARK: - WorkoutSessionContainerViewModelRepresentable

protocol WorkoutSessionContainerViewModelRepresentable {
  func transform(input: WorkoutSessionContainerViewModelInput) -> WorkoutSessionContainerViewModelOutput
}

// MARK: - WorkoutSessionContainerViewModel

final class WorkoutSessionContainerViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []

  private let oneSecondsTimerUseCase: OneSecondsTimerUseCaseRepresentable

  private let workoutRecordUseCase: WorkoutRecordUseCaseRepresentable

  private let imageUploadUseCase: MapImageUploadUseCaseRepresentable

  private weak var coordinating: WorkoutSessionCoordinating?

  private let dependency: WorkoutSessionViewModelDependency

  init(
    workoutRecordUseCase: WorkoutRecordUseCaseRepresentable,
    oneSecondsTimerUseCase: OneSecondsTimerUseCaseRepresentable,
    imageUploadUseCase: MapImageUploadUseCaseRepresentable,
    coordinating: WorkoutSessionCoordinating,
    dependency: WorkoutSessionViewModelDependency
  ) {
    self.workoutRecordUseCase = workoutRecordUseCase
    self.imageUploadUseCase = imageUploadUseCase
    self.coordinating = coordinating
    self.dependency = dependency
    self.oneSecondsTimerUseCase = oneSecondsTimerUseCase
  }
}

// MARK: WorkoutSessionContainerViewModelRepresentable

extension WorkoutSessionContainerViewModel: WorkoutSessionContainerViewModelRepresentable {
  public func transform(input: WorkoutSessionContainerViewModelInput) -> WorkoutSessionContainerViewModelOutput {
    // == Disposing of All Subscriptions ==
    subscriptions.removeAll()

    // == Input Output Binding ==

    let mapURLPublisher = input.mapCaptureImageDataPublisher
      .flatMap(imageUploadUseCase.uploadImage(included:))
      .catch { _ in Just(URL(string: "https://gblafytgdduy20857289.cdn.ntruss.com/30ab314b-a59a-44c8-b9c5-44d94b4542f0.png")!) }
      .eraseToAnyPublisher()

    let recordPublisher = input.endWorkoutPublisher
      .combineLatest(mapURLPublisher) { _, url -> URL in
        return url
      }
      .withLatestFrom(input.locationPublisher) {
        return (url: $0, locations: $1.map { LocationDTO(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) })
      }
      .withLatestFrom(input.healthPublisher) { [dependency] tuple, health in
        let workoutData = WorkoutDataForm(
          workoutTime: Int(dependency.startDate.timeIntervalSince1970.rounded(.down)),
          distance: Int(health.distance?.rounded(.toNearestOrAwayFromZero) ?? 0),
          calorie: Int(health.calorie?.rounded(.toNearestOrAwayFromZero) ?? 0),
          imageURL: tuple.url,
          locations: tuple.locations.map(\.description).joined(separator: ","),
          averageHeartRate: Int(health.averageHeartRate?.rounded(.toNearestOrAwayFromZero) ?? 0),
          minimumHeartRate: Int(health.minimumHeartRate?.rounded(.toNearestOrAwayFromZero) ?? 0),
          maximumHeartRate: Int(health.maximumHeartRate?.rounded(.toNearestOrAwayFromZero) ?? 0)
        )
        return workoutData
      }
      .flatMap(workoutRecordUseCase.record)

    recordPublisher
      .receive(on: RunLoop.main)
      .sink { _ in
        // 다른 Publisher에서 이미 처리합니다.
      } receiveValue: { [weak self] recordID in
        self?.coordinating?.pushWorkoutSummaryViewController(recordID: recordID)
      }
      .store(in: &subscriptions)

    let recordErrorPublisher = recordPublisher
      .map { _ in
        // viewModel의 Coordinator에서 처리하므로 `idle` 설정
        return WorkoutSessionContainerState.idle
      }
      .catch { return Just(.alert($0)) }
      .eraseToAnyPublisher()

    let workoutTimerPublisher = oneSecondsTimerUseCase
      .oneSecondsTimerPublisher()
      .map { WorkoutSessionContainerState.updateTime($0) }

    return Just(.idle).merge(with: recordErrorPublisher, workoutTimerPublisher).eraseToAnyPublisher()
  }
}
