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
    let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: createdAt)

    guard
      let hour = dateComponents.hour,
      let minute = dateComponents.minute,
      let second = dateComponents.second
    else {
      return nil
    }

    let startSeconds = Time(hour: hour, minute: minute, second: second).toSeconds()
    let endSeconds = startSeconds + workoutTime
    let start = prettyStyle(time: timeToHourMinuteSecond(seconds: startSeconds))
    let end = prettyStyle(time: timeToHourMinuteSecond(seconds: endSeconds))
    return (start, end)
  }

  private static func timeToHourMinuteSecond(seconds: Int) -> Time {
    var seconds = seconds
    let hour = seconds / 3600
    seconds %= 3600
    let minute = seconds / 60
    seconds %= 60
    return Time(hour: hour, minute: minute, second: seconds)
  }

  private static func prettyStyle(time: Time) -> String {
    let formattedHour = String(format: "%02d", time.hour)
    let formattedMinute = String(format: "%02d", time.minute)
    let formattedSecond = String(format: "%02d", time.second)
    return "\(formattedHour):\(formattedMinute):\(formattedSecond)"
  }
}

// MARK: - Time

private struct Time {
  let hour: Int
  let minute: Int
  let second: Int

  func toSeconds() -> Int {
    return hour * 3600 + minute * 60 + second
  }
}
