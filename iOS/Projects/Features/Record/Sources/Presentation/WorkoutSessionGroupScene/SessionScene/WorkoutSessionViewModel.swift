//
//  WorkoutSessionViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutSessionViewModelInput

public struct WorkoutSessionViewModelInput {}

public typealias WorkoutSessionViewModelOutput = AnyPublisher<WorkoutSessionState, Never>

// MARK: - WorkoutSessionState

public enum WorkoutSessionState {
  case idle
}

// MARK: - WorkoutSessionViewModelRepresentable

public protocol WorkoutSessionViewModelRepresentable {
  func transform(input: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput
}

// MARK: - WorkoutSessionViewModel

public final class WorkoutSessionViewModel {
  // MARK: Properties

  private let useCase: WorkoutSessionUseCaseRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: Initializations

  init(useCase: WorkoutSessionUseCaseRepresentable) {
    self.useCase = useCase
  }
}

// MARK: WorkoutSessionViewModelRepresentable

extension WorkoutSessionViewModel: WorkoutSessionViewModelRepresentable {
  public func transform(input _: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput {
    subscriptions.removeAll()

    let initialState: WorkoutSessionViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
