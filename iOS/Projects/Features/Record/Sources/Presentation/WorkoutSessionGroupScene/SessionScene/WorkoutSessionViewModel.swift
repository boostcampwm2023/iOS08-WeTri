//
//  WorkoutSessionViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutSessionViewModelInput

struct WorkoutSessionViewModelInput {}

typealias WorkoutSessionViewModelOutput = AnyPublisher<WorkoutSessionState, Never>

// MARK: - WorkoutSessionState

enum WorkoutSessionState {
  case idle
  case alert(Error)
}

// MARK: - WorkoutSessionViewModelRepresentable

protocol WorkoutSessionViewModelRepresentable {
  func transform(input: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput
}

// MARK: - WorkoutSessionViewModel

final class WorkoutSessionViewModel {
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
  func transform(input _: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput {
    subscriptions.removeAll()

    return Just(.idle).eraseToAnyPublisher()
  }
}
