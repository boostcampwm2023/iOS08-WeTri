//
//  RecordResponseDTO.swift
//  RecordFeature
//
//  Created by 안종표 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - RecordResponseDTO

struct RecordResponseDTO {
  let workoutTime: Int?
  let distance: Int?
  let calorie: Int?
  let avgHeartRate: Int?
  let minHeartRate: Int?
  let maxHeartRate: Int?
  let createdAt: String?
  let workout: String?
}

// MARK: Codable

extension RecordResponseDTO: Codable {}

extension Record {
  init?(dto: RecordResponseDTO) {
    guard let workout = dto.workout,
          let distance = dto.distance,
          let createdAt = dto.createdAt,
          let workoutTime = dto.workoutTime,
          let resultTimeToTime = Record.timeToTime(createdAt: createdAt, workoutTime: workoutTime)
    else {
      return nil
    }
    mode = workout
    self.distance = distance
    timeToTime = resultTimeToTime
  }

  private static func timeToTime(createdAt: String, workoutTime: Int) -> String? {
    let startTime = createdAt.components(separatedBy: " ")[1]
    guard let time = separateTime(startTime: startTime) else {
      return nil
    }
    let startSeconds = time.toSeconds()
    let endSeconds = startSeconds + workoutTime
    let start = prettyStyle(time: timeToHourMinuteSecond(seconds: startSeconds))
    let end = prettyStyle(time: timeToHourMinuteSecond(seconds: endSeconds))
    return "\(start)~\(end)"
  }

  private static func separateTime(startTime: String) -> Time? {
    let hhmmss = startTime.components(separatedBy: ":")
    guard let hour = Int(hhmmss[0]),
          let minute = Int(hhmmss[1]),
          let second = Int(hhmmss[2])
    else {
      return nil
    }

    return Time(hour: hour, minute: minute, second: second)
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
    var timeString = ""
    if time.hour < 10 {
      timeString += "0\(time.hour)"
    } else {
      timeString += "\(time.hour)"
    }
    timeString += ":"
    if time.minute < 10 {
      timeString += "0\(time.minute)"
    } else {
      timeString += "\(time.minute)"
    }
    timeString += ":"
    if time.second < 10 {
      timeString += "0\(time.second)"
    } else {
      timeString += "\(time.second)"
    }
    return timeString
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
