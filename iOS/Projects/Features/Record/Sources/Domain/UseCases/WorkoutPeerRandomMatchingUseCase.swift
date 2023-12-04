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
  func matchCancel()
  func isMatchedRandomPeer(isMatchedRandomPeersRequest: IsMatchedRandomPeersRequest) -> AnyPublisher<Result<IsMatchedRandomPeersResponse?, Error>, Never>
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
    return repository.matchStart(workoutTypeCode: workoutSetting.workoutType.typeCode)
  }

  func matchCancel() {
    return repository.matchCancel()
  }

  func isMatchedRandomPeer(isMatchedRandomPeersRequest: IsMatchedRandomPeersRequest) -> AnyPublisher<Result<IsMatchedRandomPeersResponse?, Error>, Never> {
    return repository
      .isMatchedRandomPeer(isMatchedRandomPeersRequest: isMatchedRandomPeersRequest)
      .map { result -> Result<IsMatchedRandomPeersResponse?, Error> in
        switch result {
        case let .failure(error):
          return .failure(error)
        case let .success(response):
          // 만약 매칭이 잡혔으면
          if response?.matched == true {
            return .success(response)
          }
          return .success(response)
        }
      }
      .eraseToAnyPublisher()
  }
}
