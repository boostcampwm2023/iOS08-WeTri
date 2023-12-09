//
//  LocationPathUseCase.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct LocationPathUseCase: LocationPathUseCaseRepresentable {
  func processPath(locations: [LocationModel]) -> MapRegion {
    return MapRegion(
      minLatitude: locations.map(\.latitude).min() ?? 0,
      maxLatitude: locations.map(\.latitude).max() ?? 0,
      minLongitude: locations.map(\.longitude).min() ?? 0,
      maxLongitude: locations.map(\.longitude).max() ?? 0
    )
  }
}
