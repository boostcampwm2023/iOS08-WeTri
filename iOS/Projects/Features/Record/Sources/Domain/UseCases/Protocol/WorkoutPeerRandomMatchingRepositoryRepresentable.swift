//
//  WorkoutPeerRandomMatchingRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Combine
// MARK: - WorkoutPeerRandomMatchingRepositoryRepresentable

protocol WorkoutPeerRandomMatchingRepositoryRepresentable {
  func matcheStart(workoutType: String) -> AnyPublisher<Result<Void, Error>, Never>
  func matchCancel() -> AnyPublisher<Result<Void, Error>, Never>
  func isMatchedRandomPeer() -> AnyPublisher<Result<PeerMatchResponseDTO?, Error>, Never>
}

