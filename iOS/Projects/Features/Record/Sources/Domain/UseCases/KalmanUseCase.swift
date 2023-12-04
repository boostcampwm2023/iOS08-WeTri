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
  func updateHeading(_ heading: Double)
}

// MARK: - KalmanUseCase

final class KalmanUseCase {
  var filter: KalmanFilter?

  init() {}
}

// MARK: KalmanUseCaseRepresentable

extension KalmanUseCase: KalmanUseCaseRepresentable {
  func updateHeading(_ heading: Double) {
    filter?.update(heading: heading)
  }

  func updateFilter(_ element: KalmanFilterUpdateRequireElement) -> KalmanFilterCensored? {
    if filter == nil {
      filter = .init(initLongitude: element.latitude, initLatitude: element.longitude, headingValue: 0)
      return nil
    }
    filter?.update(
      initLongitude: element.longitude,
      initLatitude: element.latitude,
      prevSpeedAtLatitude: element.prevSpeedAtLatitude,
      prevSpeedAtLongitude: element.prevSpeedAtLongitude
    )

    return filter?.latestCensoredPosition
  }
}
