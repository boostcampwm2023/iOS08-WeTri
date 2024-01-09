//
//  WorkoutHistorySelectViewModel.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - SelectWorkoutViewModelInput

public struct SelectWorkoutViewModelInput {}

public typealias SelectWorkoutViewModelOutput = AnyPublisher<SelectWorkoutState, Never>

// MARK: - SelectWorkoutState

public enum SelectWorkoutState {
  case idle
}

// MARK: - SelectWorkoutViewModelRepresentable

protocol SelectWorkoutViewModelRepresentable {
  func transform(input: SelectWorkoutViewModelInput) -> SelectWorkoutViewModelOutput
}

// MARK: - WorkoutHistorySelectViewModel

final class WorkoutHistorySelectViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: SelectWorkoutViewModelRepresentable

extension WorkoutHistorySelectViewModel: SelectWorkoutViewModelRepresentable {
  public func transform(input _: SelectWorkoutViewModelInput) -> SelectWorkoutViewModelOutput {
    subscriptions.removeAll()

    let initialState: SelectWorkoutViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
