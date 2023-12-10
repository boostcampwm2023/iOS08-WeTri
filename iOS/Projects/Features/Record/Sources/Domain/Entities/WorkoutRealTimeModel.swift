//
//  WorkoutRealTimeModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - WorkoutRealTimeModel

/// 운동 데이터를 송수신하는 모델입니다. 소켓 통신 시 사용합니다.
struct WorkoutRealTimeModel: Codable, Identifiable {
  /// User Identifier
  let id: String

  /// room Identifier
  let roomID: String

  /// 사용자 닉네임
  let nickname: String

  /// 사용자 건강 데이터
  let health: WorkoutHealthRealTimeModel

  enum CodingKeys: String, CodingKey {
    case id
    case nickname
    case health
    case roomID = "roomId"
  }
}

// MARK: - WorkoutHealthRealTimeModel

struct WorkoutHealthRealTimeModel: Codable {
  /// 총 운동한 거리
  let distance: Double?

  /// 소모한 총 칼로리
  let calories: Double?

  /// 현재 심박수
  let heartRate: Double?
}

// MARK: - WorkoutRealTimeModel + CustomStringConvertible

extension WorkoutRealTimeModel: CustomStringConvertible {
  var description: String {
    return "id: \(id)\nroomID: \(roomID)\nnickname: \(nickname)\nhealth: \(health)"
  }
}

// MARK: - WorkoutHealthRealTimeModel + CustomStringConvertible

extension WorkoutHealthRealTimeModel: CustomStringConvertible {
  var description: String {
    return "distance: \(distance ?? 0)\ncalories: \(calories ?? 0)\nheartRate: \(heartRate ?? 0)"
  }
}
