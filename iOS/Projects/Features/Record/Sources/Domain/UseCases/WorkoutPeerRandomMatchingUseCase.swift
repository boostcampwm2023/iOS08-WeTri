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
  func matchStart(workoutSetting: WorkoutSetting) -> AnyPublisher<Result<Void, Error>, Never>
  func matchCancel(workoutTypeCode: Int)
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
  func matchStart(workoutSetting: WorkoutSetting) -> AnyPublisher<Result<Void, Error>, Never> {
    return repository.matchStart(workoutTypeCode: workoutSetting.workoutType.typeCode)
  }

  func matchCancel(workoutTypeCode: Int) {
    return repository.matchCancel(workoutTypeCode: workoutTypeCode)
  }

  /// 만약 매칭이 잡혔으면 response의 값을 내려주고,
  /// 매칭에 관한 request가 제대로 전달 되었지만 매칭이 잡히지 않았을 경우 nil을 내려준다.
  func isMatchedRandomPeer(
    isMatchedRandomPeersRequest: IsMatchedRandomPeersRequest
  ) -> AnyPublisher<Result<IsMatchedRandomPeersResponse?, Error>, Never> {
    return repository
      .isMatchedRandomPeer(isMatchedRandomPeersRequest: isMatchedRandomPeersRequest)
      .map { result -> Result<IsMatchedRandomPeersResponse?, Error> in
        switch result {
        case let .failure(error):
          return .failure(error)
        case let .success(response):
          if response?.matched == true {
            return .success(response)
          }
          return .success(nil)
        }
      }
      .eraseToAnyPublisher()
  }
}
