//
//  WorkoutPeerRandomMatchingUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutPeerRandomMatchingUseCaseRepresentable

protocol WorkoutPeerRandomMatchingUseCaseRepresentable {
  func matcheStart(workoutSetting: WorkoutSetting) -> AnyPublisher<Result<Void, Error>, Never>
  func matchCancel() -> AnyPublisher<Result<Void, Error>, Never>
  func isMatchedRandomPeer() -> AnyPublisher<Result<PeerMatchResponseDTO?, Error>, Never>
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

  func isMatchedRandomPeer() -> AnyPublisher<Result<PeerMatchResponseDTO?, Error>, Never> {
    // TODO: DTO to Entity 변환 작업 필요
    return repository.isMatchedRandomPeer()
  }
}
