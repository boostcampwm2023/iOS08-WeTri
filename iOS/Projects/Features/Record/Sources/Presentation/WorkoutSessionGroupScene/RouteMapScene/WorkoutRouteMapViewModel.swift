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

public struct WorkoutRouteMapViewModelInput {}

public typealias WorkoutRouteMapViewModelOutput = AnyPublisher<WorkoutRouteMapState, Never>

// MARK: - WorkoutRouteMapState

public enum WorkoutRouteMapState {
  case idle
}

// MARK: - WorkoutRouteMapViewModelRepresentable

protocol WorkoutRouteMapViewModelRepresentable {
  func transform(input: WorkoutRouteMapViewModelInput) -> WorkoutRouteMapViewModelOutput
}

// MARK: - WorkoutRouteMapViewModel

final class WorkoutRouteMapViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: WorkoutRouteMapViewModelRepresentable

extension WorkoutRouteMapViewModel: WorkoutRouteMapViewModelRepresentable {
  public func transform(input _: WorkoutRouteMapViewModelInput) -> WorkoutRouteMapViewModelOutput {
    subscriptions.removeAll()

    let initialState: WorkoutRouteMapViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
