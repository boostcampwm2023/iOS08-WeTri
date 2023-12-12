//
//  RecordResponseDTO.swift
//  RecordFeature
//
//  Created by 안종표 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - RecordResponseDTO

struct RecordResponseDTO: Codable {
  let workoutTime: Int?
  let distance: Int?
  let calorie: Int?
  let avgHeartRate: Int?
  let minHeartRate: Int?
  let maxHeartRate: Int?
  let createdAt: Date?
  let workout: WorkoutResponseDTO?
}

// MARK: - WorkoutResponseDTO

struct WorkoutResponseDTO: Codable {
  /// 운동 이름
  let name: String?
}

extension Record {
  init?(dto: RecordResponseDTO) {
    guard let workout = dto.workout?.name,
          let distance = dto.distance,
          let createdAt = dto.createdAt,
          let workoutTime = dto.workoutTime,
          let (startTime, endTime) = Record.timeToTime(createdAt: createdAt, workoutTime: workoutTime)
    else {
      return nil
    }
    mode = workout
    self.distance = distance
    self.startTime = startTime
    self.endTime = endTime
  }

  private static func timeToTime(createdAt: Date, workoutTime: Int) -> (startTime: String, endTime: String)? {
    let endDate = createdAt
    let startDate = endDate - Double(workoutTime)
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"

    // 날짜를 문자열로 변환
    let startDateString = formatter.string(from: startDate)
    let endDateString = formatter.string(from: endDate)

    return (startDateString, endDateString)
  }
}
