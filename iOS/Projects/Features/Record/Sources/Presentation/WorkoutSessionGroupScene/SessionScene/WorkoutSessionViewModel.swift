//
//  WorkoutSessionViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutSessionViewModelInput

public struct WorkoutSessionViewModelInput {
  let endWorkoutPublisher: AnyPublisher<Void, Never>
}

public typealias WorkoutSessionViewModelOutput = AnyPublisher<WorkoutSessionState, Never>

// MARK: - WorkoutSessionState

public enum WorkoutSessionState {
  case idle
}

// MARK: - WorkoutSessionViewModelRepresentable

public protocol WorkoutSessionViewModelRepresentable {
  func transform(input: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput
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
  public func transform(input: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    input.endWorkoutPublisher
      .sink {}
      .store(in: &subscriptions)

    let initialState: WorkoutSessionViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
