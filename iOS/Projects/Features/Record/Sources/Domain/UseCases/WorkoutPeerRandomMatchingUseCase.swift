//
//  WorkoutPeerRandomMatchingUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutPeerRandomMatchingRepositoryRepresentable

// TODO: 옮겨야 할 Protocol

protocol WorkoutPeerRandomMatchingRepositoryRepresentable {
  func matcheStart(workoutType: String) -> AnyPublisher<Result<Void, Error>, Never>
  func matchCancel() -> AnyPublisher<Result<Void, Error>, Never>
  func isMatchedRandomPeer() -> AnyPublisher<Result<Void, Error>, Never>
}

// MARK: - WorkoutPeerRandomMatchingUseCaseRepresentable

protocol WorkoutPeerRandomMatchingUseCaseRepresentable {
  func matcheStart(workoutSetting: WorkoutSetting) -> AnyPublisher<Result<Void, Error>, Never>
  func matchCancel() -> AnyPublisher<Result<Void, Error>, Never>
  func isMatchedRandomPeer() -> AnyPublisher<Result<Void, Error>, Never>
}

// MARK: - WorkoutPeerRandomMatchingUseCase

struct WorkoutPeerRandomMatchingUseCase {
  private let repository: WorkoutPeerRandomMatchingRepositoryRepresentable
  init(repository: WorkoutPeerRandomMatchingRepositoryRepresentable) {
    self.repository = repository
  }
}

// MARK: WorkoutPeerRandomMatchingUseCaseRepresentable

extension WorkoutPeerRandomMatchingUseCase: WorkoutPeerRandomMatchingUseCaseRepresentable {
  func matcheStart(workoutSetting: WorkoutSetting) -> AnyPublisher<Result<Void, Error>, Never> {
    return repository.matcheStart(workoutType: workoutSetting.workoutType.description)
  }

  func matchCancel() -> AnyPublisher<Result<Void, Error>, Never> {
    return repository.matchCancel()
  }

  func isMatchedRandomPeer() -> AnyPublisher<Result<Void, Error>, Never> {
    return repository.isMatchedRandomPeer()
  }
}
