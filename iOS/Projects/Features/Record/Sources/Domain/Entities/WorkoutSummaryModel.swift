//
//  WorkoutSummaryModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/9/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - WorkoutSummaryModel

/// 운동 데이터를 요약해서 보여줄 때 사용하는 Response 모델입니다.
struct WorkoutSummaryModel {
  /// 운동 요약 정보 고유 Identifier
  let id: Int

  /// 운동한 시간
  ///
  /// 초(s)단위로 받아옵니다.
  let workoutTime: Int

  /// 총 운동한 거리
  let distance: Int

  /// 소모한 칼로리
  let calorie: Int

  /// 평균 심박수
  let averageHeartRate: Int?

  /// 운동 중에 기록한 최소 심박수
  let minimumHeartRate: Int?

  /// 운동 중에 기록한 최대 심박수
  let maximumHeartRate: Int?

  /// 운동 기록한 날짜
  let createdAt: Date

  /// 운동한 경로를 갖는 지도 이미지입니다.
  let mapScreenshots: URL

  /// 운동 위치 정보
  let locations: [LocationModel]
}

// MARK: - LocationModel

/// 위도와 경도를 나타내는 위치 정보 데이터
struct LocationModel: Codable {
  /// 위도
  let latitude: Double

  /// 경도
  let longitude: Double
}

// MARK: CustomStringConvertible

extension LocationModel: CustomStringConvertible {
  var description: String {
    return "\(latitude)/\(longitude)"
  }
}
