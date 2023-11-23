//
//  WorkoutEnvironmentSetupViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutEnvironmentSetupViewModelInput

struct WorkoutEnvironmentSetupViewModelInput {
  let requestWorkoutTypes: AnyPublisher<Void, Never>
  let requestWorkoutPeerTypes: AnyPublisher<Void, Never>
  let endWorkoutEnvironment: AnyPublisher<Void, Never>
  let selectWorkoutType: AnyPublisher<WorkoutType?, Never>
  let selectPeerType: AnyPublisher<PeerType?, Never>
}

typealias WorkoutEnvironmentSetupViewModelOutput = AnyPublisher<WorkoutEnvironmentState, Never>

// MARK: - WorkoutEnvironmentState

enum WorkoutEnvironmentState {
  case idle
  case workoutTpyes([WorkoutType])
  case workoutPeerTypes([PeerType])
  case didSelectWorkoutType(Bool)
  case didSelectWorkoutPeerType(Bool)

  case error(WorkoutEnvironmentErrorState)
}

// MARK: - WorkoutEnvironmentErrorState

enum WorkoutEnvironmentErrorState: LocalizedError {
  case unkownError
}

// MARK: - WorkoutEnvironmentSetupViewModelRepresentable

protocol WorkoutEnvironmentSetupViewModelRepresentable {
  func transform(input: WorkoutEnvironmentSetupViewModelInput) -> WorkoutEnvironmentSetupViewModelOutput
}

// MARK: - WorkoutEnvironmentSetupViewModel

final class WorkoutEnvironmentSetupViewModel {
  private var subscriptions = Set<AnyCancellable>()
  var useCase: WorkoutEnvironmentSetupUseCaseRepresentable

  var didSelectWorkoutType: WorkoutType?
  var didSelectWorkoutPeerType: PeerType?

  var workoutTypes: [WorkoutType] = []

  init(useCase: WorkoutEnvironmentSetupUseCaseRepresentable) {
    self.useCase = useCase
  }
}

// MARK: WorkoutEnvironmentSetupViewModelRepresentable

extension WorkoutEnvironmentSetupViewModel: WorkoutEnvironmentSetupViewModelRepresentable {
  func transform(input: WorkoutEnvironmentSetupViewModelInput) -> WorkoutEnvironmentSetupViewModelOutput {
    subscriptions.removeAll()

    let workoutTypes: WorkoutEnvironmentSetupViewModelOutput = input
      .requestWorkoutTypes
      .flatMap { [weak self] _ -> AnyPublisher<Result<[WorkoutType], Error>, Never> in
        guard let self else {
          return Just(Result.failure(ViewModelError.viewModelDidDeinit)).eraseToAnyPublisher()
        }
        return useCase.workoutTypes()
      }
      .map { results -> WorkoutEnvironmentState in
        switch results {
        case let .success(workOuttypes):
          let uniquePeerTypes = Array(Set(workOuttypes))
          return .workoutTpyes(uniquePeerTypes)
        case .failure:
          return .error(.unkownError)
        }
      }.eraseToAnyPublisher()

    let workoutPeerType: WorkoutEnvironmentSetupViewModelOutput = input
      .requestWorkoutPeerTypes
      .flatMap { [weak self] _ -> AnyPublisher<Result<[PeerType], Error>, Never> in
        guard let self else {
          return Just(Result.failure(ViewModelError.viewModelDidDeinit)).eraseToAnyPublisher()
        }
        return useCase.paerTypes()
      }
      .map { results -> WorkoutEnvironmentState in
        switch results {
        case let .success(peerTypes):
          let uniquePeerTypes = Array(Set(peerTypes))
          return .workoutPeerTypes(uniquePeerTypes)
        case .failure:
          return .error(.unkownError)
        }
      }.eraseToAnyPublisher()

    let didSelectWorkoutPeerType: WorkoutEnvironmentSetupViewModelOutput = input
      .selectPeerType
      .map { [weak self] peerType -> WorkoutEnvironmentState in
        guard let self else {
          return .error(.unkownError)
        }
        if let peerType {
          self.didSelectWorkoutPeerType = peerType
          return .didSelectWorkoutPeerType(true)
        }
        return .didSelectWorkoutPeerType(false)
      }.eraseToAnyPublisher()

    let didSelectWorkoutType: WorkoutEnvironmentSetupViewModelOutput = input
      .selectWorkoutType
      .map { [weak self] workoutType -> WorkoutEnvironmentState in
        guard let self else {
          return .error(.unkownError)
        }
        if let workoutType {
          self.didSelectWorkoutType = workoutType
          return .didSelectWorkoutType(true)
        }
        return .didSelectWorkoutType(false)
      }.eraseToAnyPublisher()

    let idle: WorkoutEnvironmentSetupViewModelOutput = Just(WorkoutEnvironmentState.idle).eraseToAnyPublisher()

    return Publishers.MergeMany(workoutTypes, idle, workoutPeerType, didSelectWorkoutType, didSelectWorkoutPeerType).eraseToAnyPublisher()
  }
}

// MARK: - ViewModelError

enum ViewModelError: LocalizedError {
  case viewModelDidDeinit
}