// 
//  WorkoutPeerRabdomMatchingViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutPeerRabdomMatchingViewModelInput

public struct WorkoutPeerRabdomMatchingViewModelInput {}

public typealias WorkoutPeerRabdomMatchingViewModelOutput = AnyPublisher<WorkoutPeerRabdomMatchingState, Never>

// MARK: - WorkoutPeerRabdomMatchingState

public enum WorkoutPeerRabdomMatchingState {
  case idle
}

// MARK: - WorkoutPeerRabdomMatchingViewModelRepresentable

protocol WorkoutPeerRabdomMatchingViewModelRepresentable {
  func transform(input: WorkoutPeerRabdomMatchingViewModelInput) -> WorkoutPeerRabdomMatchingViewModelOutput
}

final class WorkoutPeerRabdomMatchingViewModel {

  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

extension WorkoutPeerRabdomMatchingViewModel: WorkoutPeerRabdomMatchingViewModelRepresentable {
  public func transform(input: WorkoutPeerRabdomMatchingViewModelInput) -> WorkoutPeerRabdomMatchingViewModelOutput {
    subscriptions.removeAll()

    let initialState: WorkoutPeerRabdomMatchingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
