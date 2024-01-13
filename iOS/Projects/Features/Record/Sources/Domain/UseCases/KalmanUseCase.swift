//
//  KalmanUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import CoreLocation
import Foundation

// MARK: - KalmanUseCaseRepresentable

protocol KalmanUseCaseRepresentable {
  func updateFilter(_ element: KalmanFilterUpdateRequireElement) -> KalmanFilterCensored?
}

// MARK: - KalmanUseCase

final class KalmanUseCase {
  var filter: KalmanFilter?

  init() {}
}

// MARK: KalmanUseCaseRepresentable

extension KalmanUseCase: KalmanUseCaseRepresentable {
  func updateFilter(_ element: KalmanFilterUpdateRequireElement) -> KalmanFilterCensored? {
    if filter == nil {
      let currentLocation = element.currentCLLocation
      filter = .init(initLocation: currentLocation)
      return nil
    }
    filter?.update(currentLocation: element.currentCLLocation)

    return filter?.latestCensoredPosition
  }
}
