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
  let healthPublisher: AnyPublisher<WorkoutHealth, Never>
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

  init(workoutRecordUseCase: WorkoutRecordUseCaseRepresentable, coordinating: WorkoutSessionCoordinating) {
    self.workoutRecordUseCase = workoutRecordUseCase
    self.coordinating = coordinating
  }
}

// MARK: WorkoutSessionContainerViewModelRepresentable

extension WorkoutSessionContainerViewModel: WorkoutSessionContainerViewModelRepresentable {
  public func transform(input: WorkoutSessionContainerViewModelInput) -> WorkoutSessionContainerViewModelOutput {
    // == Disposing of All Subscriptions ==
    subscriptions.removeAll()

    // == Input Output Binding ==

    let recordPublisher = input.locationPublisher
      .map {
        $0.map { LocationDTO(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
      }
      .combineLatest(input.healthPublisher, input.endWorkoutPublisher) { location, health, _ in
        return (location, health)
      }
      .flatMap(workoutRecordUseCase.record)

    recordPublisher
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
