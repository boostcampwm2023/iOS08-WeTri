//
//  WorkoutPeerRandomMatchingRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutPeerRandomMatchingRepositoryRepresentable

protocol WorkoutPeerRandomMatchingRepositoryRepresentable {
  func matchStart(workoutTypeCode: Int) -> AnyPublisher<Result<Void, Error>, Never>
  func matchCancel()
  func isMatchedRandomPeer(isMatchedRandomPeersRequest: IsMatchedRandomPeersRequest) -> AnyPublisher<Result<IsMatchedRandomPeersResponse?, Error>, Never>
}
