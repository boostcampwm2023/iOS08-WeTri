//
//  KalmanFilter.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Log

struct KalmanFilter {
  /// 새로운 값을 입력하게 된다면, 에측을 통해서 값을 작성하게 되는 변수 입니다.
  var x = MatrixOfTwoDimension([[]])

  /// 초기 오차 공분산 입니다.
  /// 초기 값은 에러가 많기 떄문에 다음과 같이 크게 가져갔습니다.
  private var p = MatrixOfTwoDimension([
    [500, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 500, 0],
    [0, 0, 0, 1],
  ])

  // 사용자 경험을 통해 얻어진 값 입니다. (일단 대한민국 GPS환경이 좋다고 가정하여,
  // 애플 오차의 1/2로 가져갔습니다.)

  private var q = MatrixOfTwoDimension([
    [0.000455, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0.000059, 0],
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
  private var r = MatrixOfTwoDimension([
    [0.000899, 0],
    [0, 0.000117],
  ])

  var prevHeadingValue: Double
  var prevSpeedAtLatitude: Double = 0
  var prevSpeedAtLongitude: Double = 0

  /// 관계 식 입니다.
  lazy var A = MatrixOfTwoDimension([
    [1, cos(prevHeadingValue) * prevSpeedAtLatitude, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 1, sin(prevHeadingValue) * prevSpeedAtLongitude],
    [0, 0, 0, 1],
  ])

  /// 우리가 궁금한건 위도와 경도이기 때문에 필요한 부분만 기재했습니다.
  private var H = MatrixOfTwoDimension([
    [1, 0, 0, 0],
    [0, 0, 1, 0],
  ])

  init(initLongitude: Double, initLatitude: Double, headingValue: Double, processNoiseCovariance _: Double) {
    x = .init([
      [initLatitude],
      [0],
      [initLongitude],
      [0],
    ])
    prevHeadingValue = headingValue
  }

  /// 사용자가 가르키는 방향을 업데이트 합니다.
  mutating func update(heading: Double) {
    prevHeadingValue = heading
  }

  /// Update합니다.
  mutating func update(initLongitude: Double, initLatitude: Double, prevSpeedAtLatitude: Double, prevSpeedAtLongitude: Double) {
    let mesure = MatrixOfTwoDimension(
      [
        [initLatitude],
        [initLongitude],
      ]
    )
    self.prevSpeedAtLatitude = prevSpeedAtLatitude
    self.prevSpeedAtLongitude = prevSpeedAtLongitude
    guard
      let prediction = A.multiply(x),
      let predictionErrorCovariance = A.multiply(p)?.multiply(A.transPose())?.add(q),

      let notInversed = H.multiply(predictionErrorCovariance)?.multiply(H.transPose())?.add(r),
      let prevKalman = notInversed.invert(),
      let kalman = predictionErrorCovariance.multiply(H.transPose())?.multiply(prevKalman),

      let tempValue = H.multiply(prediction),
      let subTractedValue = mesure.sub(tempValue),
      let multiedKalmanValue = kalman.multiply(subTractedValue),
      let currentX = prediction.add(multiedKalmanValue),

      let tempPredictionErrorCovariance = kalman.multiply(H)?.multiply(predictionErrorCovariance),
      let currentPredictionErrorCovariance = predictionErrorCovariance.sub(tempPredictionErrorCovariance)
    else {
      return
    }
    x = currentX
    p = currentPredictionErrorCovariance
  }

  var latestCensoredPosition: KalmanFilterCensored {
    return .init(longitude: x.value[2][0], latitude: x.value[0][0])
  }
}
