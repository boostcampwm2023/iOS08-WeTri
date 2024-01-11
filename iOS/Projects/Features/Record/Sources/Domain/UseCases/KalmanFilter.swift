//
//  KalmanFilter.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import CoreLocation
import Foundation
import Log
import simd

struct KalmanFilter {
  /// 새로운 값을 입력하게 된다면, 에측을 통해서 값을 작성하게 되는 변수 입니다.
  var x = simd_double4()

  private var p = simd_double4x4([
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1],
  ])

  private var q = simd_double4x4([
    [0.00082, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0.00082, 0],
    [0, 0, 0, 0],
  ])

  /// 센서에 관한 에러입니다.
  /// 에플에서 제공하는 5m~10m사이의 에러를 Paper에서 찾았습니다.
  /// 이를 통해서 위도 경도 최대 차이를 기술하였습니다.
  ///
  /// 위도 기준
  /// 1도 일 때 몇 km ? = 지구 반지름 6371km (1도) (pi/180) = 111.19km
  /// 1º : 111190m = x : 10m
  /// x = 0.00008993614 ~= 0.000899
  ///
  /// 경도 기준
  /// 1도 일 때 몇 km? = 지구 반지름 6371 * cos(37) * 1 (pi/180) = 85.18km
  /// 1º : 85180m = y : 10m
  /// y = 0.00011739 ~= 0.000117
  private var r = simd_double2x2([
    [0.00082, 0],
    [0, 0.00082],
  ])

  /// 관계 식 입니다.
  lazy var A = simd_double4x4([
    [1, timeInterval * prevVelocity.lat, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, timeInterval * prevVelocity.long],
    [0, 0, 0, 1],
  ])

  let H = simd_double4x2([
    [1, 0],
    [0, 0],
    [0, 1],
    [0, 0],
  ])

  // 우리가 궁금한건 위도와 경도이기 때문에 필요한 부분만 기재했습니다.

  var prevTime: Date

  init(initLocation: CLLocation) {
    x = .init(initLocation.coordinate.latitude, 0, initLocation.coordinate.longitude, 0)
    prevTime = initLocation.timestamp
  }

  var timeInterval: Double = 0.0

  var prevLocation = CLLocation()

  let pIdentity = simd_double4x4([
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0],
    [0, 0, 0, 1],
  ])

  var prevVelocity: (lat: Double, long: Double) = (0, 0)

  mutating func update(currentLocation: CLLocation) {
    let currentTime = currentLocation.timestamp

    let prevTimeInterval = prevTime.timeIntervalSince1970
    let currentTimeInterval = currentTime.timeIntervalSince1970

    timeInterval = currentTimeInterval - prevTimeInterval

    let velocityLatitude = (prevLocation.coordinate.latitude - currentLocation.coordinate.latitude)
    let velocityLongitude = (prevLocation.coordinate.longitude - currentLocation.coordinate.longitude)

    prevVelocity = (velocityLatitude, velocityLongitude)

    prevLocation = currentLocation
    prevTime = currentTime

    let mesure = simd_double2(
      [
        currentLocation.coordinate.latitude,
        currentLocation.coordinate.longitude,
      ]
    )

    let xp = A * x
    let pp = A * p * A.transpose + q

    let temp = pp * H.transpose
    let invert = (H * pp * H.transpose + r).inverse
    let kalman = temp * invert

    let currentX = xp + kalman * (mesure - H * xp)

    let currentP = pp - kalman * H * pp.inverse
    x = currentX
    p = currentP
  }

  var latestCensoredPosition: KalmanFilterCensored {
    return .init(longitude: x[2], latitude: x[0])
  }
}
