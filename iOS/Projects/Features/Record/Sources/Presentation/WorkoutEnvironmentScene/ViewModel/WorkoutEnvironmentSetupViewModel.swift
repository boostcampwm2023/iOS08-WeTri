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

typealias WorkoutEnvironmentSetupViewModelOutput = AnyPublisher<Result<WorkoutEnvironmentState, Error>, Never>

// MARK: - WorkoutEnvironmentState

enum WorkoutEnvironmentState {
  case idle
  case workoutTpyes([WorkoutType])
  case workoutPeerTypes([PeerType])
  case didSelectWorkoutType(Bool)
  case didSelectWorkoutPeerType(Bool)
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
      }.eraseToAnyPublisher()

    let workoutPeerType: WorkoutEnvironmentSetupViewModelOutput = input
      .requestWorkoutPeerTypes
      .flatMap { _ in
        self.useCase.paerTypes()
      }
      .map { results -> Result<WorkoutEnvironmentState, Error> in
        switch results {
        case let .success(success):
          return .success(.workoutPeerTypes(success))
        case let .failure(failure):
          return .failure(failure)
        }
      }.eraseToAnyPublisher()

    let didSelectWorkoutPeerType: WorkoutEnvironmentSetupViewModelOutput = input
      .selectPeerType
      .map { [weak self] peerType -> Result<WorkoutEnvironmentState, Error> in
        guard let self else {
          return .failure(ViewModelError.viewModelDidDeinit)
        }
        if let peerType {
          self.didSelectWorkoutPeerType = peerType
          return .success(.didSelectWorkoutPeerType(true))
        }
        return .success(.didSelectWorkoutPeerType(false))
      }.eraseToAnyPublisher()

    let didSelectWorkoutType: WorkoutEnvironmentSetupViewModelOutput = input
      .selectWorkoutType
      .map { [weak self] workoutType -> Result<WorkoutEnvironmentState, Error> in
        guard let self else {
          return .failure(ViewModelError.viewModelDidDeinit)
        }
        if let workoutType {
          self.didSelectWorkoutType = workoutType
          return .success(.didSelectWorkoutType(true))
        }
        return .success(.didSelectWorkoutType(false))
      }.eraseToAnyPublisher()

    let idle: WorkoutEnvironmentSetupViewModelOutput = Just(Result.success(WorkoutEnvironmentState.idle)).eraseToAnyPublisher()

    return Publishers.Merge5(workoutTypes, idle, workoutPeerType, didSelectWorkoutType, didSelectWorkoutPeerType).eraseToAnyPublisher()
  }
}

// MARK: - ViewModelError

enum ViewModelError: LocalizedError {
  case viewModelDidDeinit
}
