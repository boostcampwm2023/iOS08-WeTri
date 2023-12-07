//
//  WorkoutRouteMapViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutRouteMapViewModelInput

public struct WorkoutRouteMapViewModelInput {
  let filterShouldUpdatePositionPublisher: AnyPublisher<KalmanFilterUpdateRequireElement, Never>
  let filterShouldUpdateHeadingPublisher: AnyPublisher<Double, Never>
}

public typealias WorkoutRouteMapViewModelOutput = AnyPublisher<WorkoutRouteMapState, Never>

// MARK: - WorkoutRouteMapState

public enum WorkoutRouteMapState {
  case idle
  case censoredValue(KalmanFilterCensored?)
}

// MARK: - WorkoutRouteMapViewModelRepresentable

protocol WorkoutRouteMapViewModelRepresentable {
  func transform(input: WorkoutRouteMapViewModelInput) -> WorkoutRouteMapViewModelOutput
}

// MARK: - WorkoutRouteMapViewModel

final class WorkoutRouteMapViewModel {
  // MARK: - Properties

  var kalmanUseCase: KalmanUseCaseRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  init(kalmanUseCase: KalmanUseCaseRepresentable) {
    self.kalmanUseCase = kalmanUseCase
  }
}

// MARK: WorkoutRouteMapViewModelRepresentable

extension WorkoutRouteMapViewModel: WorkoutRouteMapViewModelRepresentable {
  public func transform(input: WorkoutRouteMapViewModelInput) -> WorkoutRouteMapViewModelOutput {
    subscriptions.removeAll()

    input
      .filterShouldUpdateHeadingPublisher
      .dropFirst(4)
      .sink { [kalmanUseCase] value in
        kalmanUseCase.updateHeading(value)
      }
      .store(in: &subscriptions)

    let updateValue: WorkoutRouteMapViewModelOutput = input
      .filterShouldUpdatePositionPublisher
      .dropFirst(4)
      .map { [kalmanUseCase] element in
        let censoredValue = kalmanUseCase.updateFilter(element)
        return WorkoutRouteMapState.censoredValue(censoredValue)
      }
      .eraseToAnyPublisher()

    let initialState: WorkoutRouteMapViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateValue).eraseToAnyPublisher()
  }
}
