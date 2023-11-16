//
//  WorkoutSummaryViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutSummaryViewModelInput

public struct WorkoutSummaryViewModelInput {}

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

public final class WorkoutSummaryViewModel {
  // MARK: Properties

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: Initializations

  public init() {}
}

// MARK: WorkoutSummaryViewModelRepresentable

extension WorkoutSummaryViewModel: WorkoutSummaryViewModelRepresentable {
  public func transform(input _: WorkoutSummaryViewModelInput) -> WorkoutSummaryViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let initialState: WorkoutSummaryViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
