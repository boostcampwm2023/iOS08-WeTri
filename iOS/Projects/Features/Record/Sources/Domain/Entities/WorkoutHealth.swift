//
//  WorkoutHealth.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/25/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 건강 데이터를 body로 전달하기 위한 요청(request) 모델입니다. 운동 세션이 종료될 때 이 모델을 사용합니다.
public struct WorkoutHealth: Encodable {
  /// 총 운동한 거리
  let distance: Int?

  /// 소모한 칼로리
  let calorie: Int?

  /// 평균 심박수
  let averageHeartRate: Int?

  /// 운동 중에 기록한 최소 심박수
  let minimumHeartRate: Int?

  /// 운동 중에 기록한 최대 심박수
  let maximumHeartRate: Int?
}
