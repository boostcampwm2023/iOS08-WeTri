//
//  WorkoutSessionContainerViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

// MARK: - WorkoutSessionContainerViewModelInput

public struct WorkoutSessionContainerViewModelInput {
  let endWorkoutPublisher: AnyPublisher<Void, Never>
  let locationPublisher: AnyPublisher<[CLLocation], Never>
  let healthPublisher: AnyPublisher<WorkoutHealthForm, Never>
}

public typealias WorkoutSessionContainerViewModelOutput = AnyPublisher<WorkoutSessionContainerState, Never>

// MARK: - WorkoutSessionContainerState

public enum WorkoutSessionContainerState {
  case idle
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

  private let workoutRecordUseCase: WorkoutRecordUseCaseRepresentable

  private weak var coordinating: WorkoutSessionCoordinating?

  private let startDate: Date

  init(
    workoutRecordUseCase: WorkoutRecordUseCaseRepresentable,
    coordinating: WorkoutSessionCoordinating,
    startDate: Date
  ) {
    self.workoutRecordUseCase = workoutRecordUseCase
    self.coordinating = coordinating
    self.startDate = startDate
  }
}

// MARK: WorkoutSessionContainerViewModelRepresentable

extension WorkoutSessionContainerViewModel: WorkoutSessionContainerViewModelRepresentable {
  public func transform(input: WorkoutSessionContainerViewModelInput) -> WorkoutSessionContainerViewModelOutput {
    // == Disposing of All Subscriptions ==
    subscriptions.removeAll()

    // == Input Output Binding ==

    let recordPublisher = input.endWorkoutPublisher
      .combineLatest(input.locationPublisher, input.healthPublisher) { [startDate] _, rawLocations, health in
        let locations = rawLocations.map { LocationDTO(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
        let healthData = WorkoutDataForm(
          workoutTime: Int(startDate.timeIntervalSince1970.rounded(.down)),
          distance: Int(health.distance?.rounded(.toNearestOrAwayFromZero) ?? 0),
          calorie: Int(health.calorie?.rounded(.toNearestOrAwayFromZero) ?? 0),
          averageHeartRate: Int(health.averageHeartRate?.rounded(.toNearestOrAwayFromZero) ?? 0),
          minimumHeartRate: Int(health.minimumHeartRate?.rounded(.toNearestOrAwayFromZero) ?? 0),
          maximumHeartRate: Int(health.maximumHeartRate?.rounded(.toNearestOrAwayFromZero) ?? 0)
        )

        return (locations, healthData)
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

    let initialState: WorkoutSessionContainerViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: recordErrorPublisher).eraseToAnyPublisher()
  }
}
