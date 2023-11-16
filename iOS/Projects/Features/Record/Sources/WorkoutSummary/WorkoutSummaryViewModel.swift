//
//  WorkoutSummaryViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutSummaryPresentableListener

public protocol WorkoutSummaryPresentableListener: AnyObject {
  func moveToResult()
}

// MARK: - WorkoutSummaryViewModelInput

public struct WorkoutSummaryViewModelInput {
  let workoutFinished: AnyPublisher<Void, Never>
}

public typealias WorkoutSummaryViewModelOutput = AnyPublisher<WorkoutSummaryState, Never>

// MARK: - WorkoutSummaryState

public enum WorkoutSummaryState {
  case idle
}

// MARK: - WorkoutSummaryViewModelRepresentable

public protocol WorkoutSummaryViewModelRepresentable {
  func transform(input: WorkoutSummaryViewModelInput) -> WorkoutSummaryViewModelOutput
}

// MARK: - WorkoutSummaryViewModel

public final class WorkoutSummaryViewModel: WorkoutSummaryPresentable {
  // MARK: - Properties

  public weak var listener: WorkoutSummaryPresentableListener?

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: WorkoutSummaryViewModelRepresentable

extension WorkoutSummaryViewModel: WorkoutSummaryViewModelRepresentable {
  public func transform(input: WorkoutSummaryViewModelInput) -> WorkoutSummaryViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    input.workoutFinished
      .sink { [weak self] _ in
        self?.listener?.moveToResult()
      }
      .store(in: &subscriptions)

    let initialState: WorkoutSummaryViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
