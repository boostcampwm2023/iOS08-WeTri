//
//  MapRegion.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 측정된 위도와 경도를 통해서, 최댓값 및 최솟값을 나타냅니다.
public struct MapRegion {
  
  /// 측정된 거리에의 위도 중에서, 가장 큰 작은 값 입니다.
  var minLatitude: Double
  
  /// 측정된 거릐의 위도 중에서, 가장 작은 큰 값 입니다.
  var maxLatitude: Double
  
  /// 측정된 거리의 경도 중에서, 가장 작은 값 입니다.
  var minLongitude: Double
  
  /// 측정된 거리의 경도 중에서, 가장 작은 큰 값 입니다.
  var maxLongitude: Double
}
