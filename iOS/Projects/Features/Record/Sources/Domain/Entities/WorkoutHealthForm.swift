//
//  WorkoutHealthForm.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 자신이 기록한 건강 데이터를 저장할 때 사용합니다.
public struct WorkoutHealthForm {
  /// 총 운동한 거리
  let distance: Double?

  /// 소모한 칼로리
  let calorie: Double?

  /// 평균 심박수
  let averageHeartRate: Double?

  /// 운동 중에 기록한 최소 심박수
  let minimumHeartRate: Double?

  /// 운동 중에 기록한 최대 심박수
  let maximumHeartRate: Double?
}
