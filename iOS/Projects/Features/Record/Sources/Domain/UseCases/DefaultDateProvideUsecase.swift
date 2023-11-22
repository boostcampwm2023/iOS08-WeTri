//
//  DefaultDateProvideUsecase.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/22.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - DefaultDateProvideUsecase

final class DefaultDateProvideUsecase: DateProvideUsecase {
  func today() -> DateInfo {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd-EEEE"
    let dateInformation = dateFormatter
      .string(from: currentDate)
      .split(separator: "-")
      .map { String($0) }
    let year = dateInformation[0]
    let month = dateInformation[1]
    let date = dateInformation[2]
    let dayOfWeek = DayOfWeek(rawValue: dateInformation[3])?.korean

    return DateInfo(
      year: year,
      month: month,
      date: date,
      dayOfWeek: dayOfWeek
    )
  }
}

// MARK: - DayOfWeek

private enum DayOfWeek: String {
  case sunday = "Sunday"
  case monday = "Monday"
  case tuesday = "Tuesday"
  case wednesday = "Wednesday"
  case thursday = "Thursday"
  case friday = "Friday"
  case saturday = "Saturday"
}

private extension DayOfWeek {
  var korean: String {
    switch self {
    case .sunday:
      return "일요일"
    case .monday:
      return "월요일"
    case .tuesday:
      return "화요일"
    case .wednesday:
      return "수요일"
    case .thursday:
      return "목요일"
    case .friday:
      return "금요일"
    case .saturday:
      return "토요일"
    }
  }
}
