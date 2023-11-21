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
  let endWorkoutEnvironment: AnyPublisher<Void, Never>
}

typealias WorkoutEnvironmentSetupViewModelOutput = AnyPublisher<Result<WorkoutEnvironmentState, Error>, Never>

// MARK: - WorkoutEnvironmentState

enum WorkoutEnvironmentState {
  case idle
  case workoutTpyes([WorkoutType])
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
    
    let workOutTypes: WorkoutEnvironmentSetupViewModelOutput = input
      .requestWorkoutTypes
      .flatMap { [weak self] _ -> WorkoutEnvironmentSetupViewModelOutput in
        guard let self else {
          return Just(Result.failure(DomainError.didDeinitUseCase)).eraseToAnyPublisher()
        }
        
        return useCase.workoutTypes()
          .map { results -> Result<WorkoutEnvironmentState, Error> in
            switch results {
            case .success(let workoutTypes) :
              return .success(.workoutTpyes(workoutTypes))
            case .failure(let error) :
              return .failure(error)
            }
          }
          .eraseToAnyPublisher()
      }.eraseToAnyPublisher()
    
    
    let initalState: WorkoutEnvironmentSetupViewModelOutput = Just(Result.success(WorkoutEnvironmentState.idle)).eraseToAnyPublisher()
    
    input
      .requestWorkoutTypes
      .sink { [weak self] _ in
        guard let self else { return }
        Task {
          do {
            let result = try await self.useCase.workoutTpyes()
            self.subject.send(.success(.workoutTpyes(result)))
          } catch {
            self.subject.send(.failure(error))
          }
        }
      }
      .store(in: &subscriptions)

    input
      .endWorkoutEnvironment
      .sink {}
      .store(in: &subscriptions)

    return Publishers.Merge(initalState, workOutTypes).eraseToAnyPublisher()
  }
}
