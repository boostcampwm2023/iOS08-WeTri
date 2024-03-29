//
//  Record.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - Record

/// 기록 목록을 표시하기위해 사용하는 모델입니다.
public struct Record: Codable, Hashable {
  /// 현재 운동의 날짜를 나타냅니다.
  let dateString: String

  /// 현재 운동의 목록을 나타냅니다.
  let workoutID: Int

  /// 운동 시작 시간
  ///
  /// HH:MM 으로 표시
  let startTime: String

  /// 운동 끝 시간
  ///
  /// HH:MM 으로 표시
  let endTime: String

  /// 총 운동한 거리를 "미터"단위로 표시해줍니다.
  let distance: Int
}

public extension Record {
  var name: String {
    switch workoutID {
    case 1:
      return "달리기"
    case 2:
      return "수영"
    case 3:
      return "사이클"
    default:
      return "달리기"
    }
  }

  var durationTime: String {
    guard
      let endDate = DateFormatter.HHmmFormatter.date(from: endTime),
      let startDate = DateFormatter.HHmmFormatter.date(from: startTime)
    else {
      return ""
    }
    let timeInterval = endDate.timeIntervalSince(startDate)
    let hours = Int(timeInterval / 3600)
    let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
    if minutes == 0 {
      return hours == 0 ? "" : "\(hours)시간"
    }
    return hours == 0 ? "\(minutes)분" : "\(hours)시간\(minutes)분"
  }
}

private extension DateFormatter {
  static let HHmmFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
  }()
}
