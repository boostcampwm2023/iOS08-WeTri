//
//  WorkoutEnvironmentSetupViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutEnvironmentSetupViewModelInput

struct WorkoutEnvironmentSetupViewModelInput {
  let requestWorkoutTypes: AnyPublisher<Void, Never>
  let requestWorkoutPeerTypes: AnyPublisher<Void, Never>
  let endWorkoutEnvironment: AnyPublisher<Void, Never>
}

typealias WorkoutEnvironmentSetupViewModelOutput = AnyPublisher<Result<WorkoutEnvironmentState, Error>, Never>

// MARK: - WorkoutEnvironmentState

enum WorkoutEnvironmentState {
  case idle
  case workoutTpyes([WorkoutType])
  case workoutPeerTypes([PeerType])
}

// MARK: - WorkoutEnvironmentSetupViewModelRepresentable

protocol WorkoutEnvironmentSetupViewModelRepresentable {
  func transform(input: WorkoutEnvironmentSetupViewModelInput) -> WorkoutEnvironmentSetupViewModelOutput
}

// MARK: - WorkoutEnvironmentSetupViewModel

final class WorkoutEnvironmentSetupViewModel {
  private var subscriptions = Set<AnyCancellable>()
  var useCase: WorkoutEnvironmentSetupUseCaseRepresentable
  var subject = PassthroughSubject<Result<WorkoutEnvironmentState, Error>, Never>()
  var workoutTypes: [WorkoutType] = []

  init(useCase: WorkoutEnvironmentSetupUseCaseRepresentable) {
    self.useCase = useCase
  }
}

// MARK: WorkoutEnvironmentSetupViewModelRepresentable

extension WorkoutEnvironmentSetupViewModel: WorkoutEnvironmentSetupViewModelRepresentable {
  func transform(input: WorkoutEnvironmentSetupViewModelInput) -> WorkoutEnvironmentSetupViewModelOutput {
    subscriptions.removeAll()

    let workoutTypes = input
      .requestWorkoutTypes
      .flatMap { _ in
        self.useCase.workoutTypes()
      }
      .map { results -> Result<WorkoutEnvironmentState, Error> in
        switch results {
        case let .success(workOuttypes):
          return .success(.workoutTpyes(workOuttypes))
        case let .failure(error):
          return Result.failure(error)
        }
      }
    
    let workoutPeerType: WorkoutEnvironmentSetupViewModelOutput = input
      .requestWorkoutPeerTypes
      .flatMap { _ in
        self.useCase.paerTypes()
      }
      .map { results -> Result<WorkoutEnvironmentState, Error> in
        switch results {
        case .success(let success):
          return .success(.workoutPeerTypes(success))
        case .failure(let failure):
          return .failure(failure)
        }
      }.eraseToAnyPublisher()

    let idle: WorkoutEnvironmentSetupViewModelOutput = Just(Result.success(WorkoutEnvironmentState.idle)).eraseToAnyPublisher()

    return Publishers.Merge3(workoutTypes, idle, workoutPeerType).eraseToAnyPublisher()
  }
}
