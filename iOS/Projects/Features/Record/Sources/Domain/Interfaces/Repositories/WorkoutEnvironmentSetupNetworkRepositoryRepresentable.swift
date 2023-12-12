//
//  WorkoutEnvironmentSetupNetworkRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/22/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutEnvironmentSetupNetworkRepositoryRepresentable

protocol WorkoutEnvironmentSetupNetworkRepositoryRepresentable {
  func workoutTypes() -> AnyPublisher<[WorkoutTypeDTO], Error>
  func peerType() -> AnyPublisher<[PeerTypeDTO], Error>
}
