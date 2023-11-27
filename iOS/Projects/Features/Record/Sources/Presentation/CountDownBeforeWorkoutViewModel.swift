//
//  CountDownBeforeWorkoutViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/27/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - CountDownBeforeWorkoutViewModelInput

public struct CountDownBeforeWorkoutViewModelInput {}

public typealias CountDownBeforeWorkoutViewModelOutput = AnyPublisher<CountDownBeforeWorkoutState, Never>

// MARK: - CountDownBeforeWorkoutState

public enum CountDownBeforeWorkoutState {
  case idle
}

// MARK: - CountDownBeforeWorkoutViewModelRepresentable

protocol CountDownBeforeWorkoutViewModelRepresentable {
  func transform(input: CountDownBeforeWorkoutViewModelInput) -> CountDownBeforeWorkoutViewModelOutput
}

// MARK: - CountDownBeforeWorkoutViewModel

final class CountDownBeforeWorkoutViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: CountDownBeforeWorkoutViewModelRepresentable

extension CountDownBeforeWorkoutViewModel: CountDownBeforeWorkoutViewModelRepresentable {
  public func transform(input _: CountDownBeforeWorkoutViewModelInput) -> CountDownBeforeWorkoutViewModelOutput {
    subscriptions.removeAll()

    let initialState: CountDownBeforeWorkoutViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
