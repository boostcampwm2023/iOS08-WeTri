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

public struct SelectWorkoutViewModelInput {
  let selectCell: AnyPublisher<Record, Never>
}

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
  weak var writeBoardCoordinator: WriteBoardCoordinator?
}

// MARK: SelectWorkoutViewModelRepresentable

extension WorkoutHistorySelectViewModel: SelectWorkoutViewModelRepresentable {
  public func transform(input: SelectWorkoutViewModelInput) -> SelectWorkoutViewModelOutput {
    subscriptions.removeAll()

    input.selectCell
      .sink { [weak self] record in
        self?.writeBoardCoordinator?.pushWriteBoardScene(record: record)
      }
      .store(in: &subscriptions)

    let initialState: SelectWorkoutViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
