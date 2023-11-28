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
  // FIXME: API Model로 바꿔야합니다.
  case connectHealthData(distance: Double, calories: Double, heartRate: Double)
  case alert(Error)
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

    let healthData = useCase.healthPublisher
      .map(WorkoutSessionState.connectHealthData)
      .catch { Just(.alert($0)) }

    return initialState.merge(with: healthData).eraseToAnyPublisher()
  }
}
