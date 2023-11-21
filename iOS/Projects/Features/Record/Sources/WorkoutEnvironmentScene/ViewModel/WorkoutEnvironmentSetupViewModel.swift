//
//  WorkoutEnvironmentSetupViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutEnvironmentViewModelInput

struct WorkoutEnvironmentViewModelInput {
  let endWorkoutEnvironment: AnyPublisher<Void, Never>
}

typealias WorkoutEnvironmentViewModelOutput = AnyPublisher<WorkoutEnvironmentState, Never>

// MARK: - WorkoutEnvironmentState

enum WorkoutEnvironmentState {
  case idle
}

// MARK: - WorkoutEnvironmentViewModelRepresentable

protocol WorkoutEnvironmentViewModelRepresentable {
  func transform(input: WorkoutEnvironmentViewModelInput) -> WorkoutEnvironmentViewModelOutput
}

// MARK: - WorkoutEnvironmentViewModel

final class WorkoutEnvironmentViewModel {
  private var subscriptions = Set<AnyCancellable>()

  init() {}
}

// MARK: WorkoutEnvironmentViewModelRepresentable

extension WorkoutEnvironmentViewModel: WorkoutEnvironmentViewModelRepresentable {
  func transform(input: WorkoutEnvironmentViewModelInput) -> WorkoutEnvironmentViewModelOutput {
    subscriptions.removeAll()

    input
      .endWorkoutEnvironment
      .sink {}
      .store(in: &subscriptions)

    let initialState: WorkoutEnvironmentViewModelOutput = Just(.idle).eraseToAnyPublisher()
    return initialState
  }
}
