//
//  LocationPathUseCase.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct LocationPathUseCase: LocationPathUseCaseRepresentable {
  func processPath(locations: [LocationDTO]) -> MapRegion {
    guard let firstLocation = locations.first else {
      return MapRegion(minLatitude: 0, maxLatitude: 0, minLongitude: 0, maxLongitude: 0)
    }

    var minLatitude = firstLocation.latitude
    var minLongitude = firstLocation.longitude
    var maxLatitude = minLatitude
    var maxLongitude = minLongitude

    for location in locations {
      minLatitude = min(minLatitude, location.latitude)
      minLongitude = min(minLongitude, location.longitude)
      maxLatitude = max(maxLatitude, location.latitude)
      maxLongitude = max(maxLongitude, location.longitude)
    }

    return MapRegion(
      minLatitude: minLatitude,
      maxLatitude: maxLatitude,
      minLongitude: minLongitude,
      maxLongitude: maxLongitude
    )
  }
}
