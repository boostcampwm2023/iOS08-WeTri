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
  let locationListPublisher: AnyPublisher<[LocationModel], Never>
}

public typealias WorkoutRouteMapViewModelOutput = AnyPublisher<WorkoutRouteMapState, Never>

// MARK: - WorkoutRouteMapState

public enum WorkoutRouteMapState {
  case idle
  case snapshotRegion(MapRegion)
  case censoredValue(KalmanFilterCensored?)
}

// MARK: - WorkoutRouteMapViewModelRepresentable

protocol WorkoutRouteMapViewModelRepresentable {
  func transform(input: WorkoutRouteMapViewModelInput) -> WorkoutRouteMapViewModelOutput
}

// MARK: - WorkoutRouteMapViewModel

final class WorkoutRouteMapViewModel {
  // MARK: - Properties

  private let kalmanUseCase: KalmanUseCaseRepresentable
  private let locationPathUseCase: LocationPathUseCaseRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  init(
    kalmanUseCase: KalmanUseCaseRepresentable,
    locationPathUseCase: LocationPathUseCaseRepresentable
  ) {
    self.kalmanUseCase = kalmanUseCase
    self.locationPathUseCase = locationPathUseCase
  }
}

// MARK: WorkoutRouteMapViewModelRepresentable

extension WorkoutRouteMapViewModel: WorkoutRouteMapViewModelRepresentable {
  public func transform(input: WorkoutRouteMapViewModelInput) -> WorkoutRouteMapViewModelOutput {
    subscriptions.removeAll()

    let region = input
      .locationListPublisher
      .map(locationPathUseCase.processPath(locations:))
      .map(WorkoutRouteMapState.snapshotRegion)

    let updateValue: WorkoutRouteMapViewModelOutput = input
      .filterShouldUpdatePositionPublisher
      .dropFirst(4)
      .throttle(for: 1, scheduler: RunLoop.main, latest: false)
      .map { [kalmanUseCase] element in
        let censoredValue = kalmanUseCase.updateFilter(element)
        return WorkoutRouteMapState.censoredValue(censoredValue)
      }
      .eraseToAnyPublisher()

    let initialState: WorkoutRouteMapViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: updateValue, region).eraseToAnyPublisher()
  }
}
