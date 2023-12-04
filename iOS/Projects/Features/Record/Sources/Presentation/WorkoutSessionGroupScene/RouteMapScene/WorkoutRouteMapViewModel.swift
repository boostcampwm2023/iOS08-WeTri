//
//  WorkoutRouteMapViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - KalmanFilterUpdateRequireElement

struct KalmanFilterUpdateRequireElement {
  let longitude: Double
  let latitude: Double
  let prevSpeedAtLongitude: Double
  let prevSpeedAtLatitude: Double
}

// MARK: - KalmanFilterCensored

public struct KalmanFilterCensored {
  let longitude: Double
  let latitude: Double
}

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

  var useCase: KalmanUseCaseRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  init(useCase: KalmanUseCaseRepresentable) {
    self.useCase = useCase
  }
}

// MARK: WorkoutRouteMapViewModelRepresentable

extension WorkoutRouteMapViewModel: WorkoutRouteMapViewModelRepresentable {
  public func transform(input: WorkoutRouteMapViewModelInput) -> WorkoutRouteMapViewModelOutput {
    subscriptions.removeAll()

    input
      .filterShouldUpdateHeadingPublisher
      .sink { [useCase] value in
        useCase.updateHeading(value)
      }
      .store(in: &subscriptions)

    let updateValue: WorkoutRouteMapViewModelOutput = input
      .filterShouldUpdatePositionPublisher
      .map { [useCase] element in
        let censoredValue = useCase.updateFilter(element)
        return WorkoutRouteMapState.censoredValue(censoredValue)
      }
      .eraseToAnyPublisher()

    let initialState: WorkoutRouteMapViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateValue).eraseToAnyPublisher()
  }
}

// MARK: - WorkoutRouteMapViewModelError

enum WorkoutRouteMapViewModelError: LocalizedError {
  case nullData
}
