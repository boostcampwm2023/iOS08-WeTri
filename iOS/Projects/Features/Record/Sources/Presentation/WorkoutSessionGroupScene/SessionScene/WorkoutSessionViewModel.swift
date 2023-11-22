//
//  WorkoutSessionViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutSummaryViewModelInput

public struct WorkoutSummaryViewModelInput {
  let endWorkoutPublisher: AnyPublisher<Void, Never>
}

public typealias WorkoutSummaryViewModelOutput = AnyPublisher<WorkoutSummaryState, Never>

// MARK: - WorkoutSummaryState

public enum WorkoutSummaryState {
  case idle
}

// MARK: - WorkoutSessionViewModelRepresentable

public protocol WorkoutSessionViewModelRepresentable {
  func transform(input: WorkoutSummaryViewModelInput) -> WorkoutSummaryViewModelOutput
}

// MARK: - WorkoutSessionViewModel

public final class WorkoutSessionViewModel {
  // MARK: Properties

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: Initializations

  public init() {}
}

// MARK: WorkoutSessionViewModelRepresentable

extension WorkoutSessionViewModel: WorkoutSessionViewModelRepresentable {
  public func transform(input: WorkoutSummaryViewModelInput) -> WorkoutSummaryViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    input.endWorkoutPublisher
      .sink {}
      .store(in: &subscriptions)

    let initialState: WorkoutSummaryViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
