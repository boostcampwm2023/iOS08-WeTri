//
//  HealthRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol HealthRepositoryRepresentable {
  /// 심박수를 가져옵니다. 같은 시작시간으로 요청해도 알아서 중복된 데이터를 제외하고 가져와줍니다.
  /// - Parameter startDate: 데이터를 가져올 시작 시간대
  /// - Returns: 심박수 데이터(bpm)
  func getHeartRateSample(startDate: Date) -> AnyPublisher<[Double], Error>

  /// 달리거나 걸었을 때의 거리를 가져옵니다. 같은 시작시간으로 요청해도 알아서 중복된 데이터를 제외하고 가져와줍니다.
  /// - Parameter startDate: 데이터를 가져올 시작 시간대
  /// - Returns: 지나온 거리(m)
  func getDistanceWalkingRunningSample(startDate: Date) -> AnyPublisher<[Double], Error>

  /// 소모한 칼로리를 가져옵니다.. 같은 시작시간으로 요청해도 알아서 중복된 데이터를 제외하고 가져와줍니다.
  /// - Parameter startDate: 데이터를 가져올 시작 시간대
  /// - Returns: 칼로리(kcal)
  func getCaloriesSample(startDate: Date) -> AnyPublisher<[Double], Error>
}
