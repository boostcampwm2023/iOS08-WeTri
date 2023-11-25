//
//  DateProvideUseCase.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/22.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import OSLog

// MARK: - DateProvideUseCase

final class DateProvideUseCase: DateProvideUseCaseRepresentable {
  private var dateInfos: [DateInfo] = []
  private let calendar = Calendar.current

  func today() -> Date {
    let currentDate = Date()
    return currentDate
  }

  func todayIndex(sectionCount: Int) -> IndexPath {
    let date: Date = today()
    let todayDateInfo = transform(date: date)
    for (index, dateInfo) in dateInfos.enumerated() {
      guard dateInfo == todayDateInfo else { continue }
      return IndexPath(item: index, section: sectionCount)
    }
    return IndexPath(item: 0, section: sectionCount)
  }

  func transform(dateInfo: DateInfo) -> Date? {
    guard let year = Int(dateInfo.year),
          let month = Int(dateInfo.month),
          let date = Int(dateInfo.date)
    else {
      return nil
    }
    let dateComponents = DateComponents(year: year, month: month, day: date)
    guard let date = calendar.date(from: dateComponents) else {
      return nil
    }
    return date
  }

  func transform(date: Date) -> DateInfo {
    let dateInformation = formatter()
      .string(from: date)
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

  func fetchAllDatesThisMonth() -> [DateInfo] {
    let today = today()
    let todayDateInfo = transform(date: today)

    guard let thisYear = Int(todayDateInfo.year),
          let thisMonth = Int(todayDateInfo.month)
    else {
      return dateInfos
    }
    let startDateComponents = DateComponents(year: thisYear, month: thisMonth)
    let endDateComponents = DateComponents(year: thisYear, month: thisMonth + 1, day: 0)

    guard let startDate = calendar.date(from: startDateComponents),
          let endDate = calendar.date(from: endDateComponents)
    else {
      return dateInfos
    }
    var currentDate = startDate
    while currentDate <= endDate {
      let day = dayFormatter().string(from: currentDate)
      let dayOfWeek = dayOfWeekFormatter().string(from: currentDate)

      dateInfos.append(
        DateInfo(
          year: "\(thisYear)",
          month: "\(thisMonth)",
          date: day,
          dayOfWeek: DayOfWeek(rawValue: dayOfWeek)?.korean
        )
      )
      guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
        break
      }
      currentDate = nextDate
    }
    return dateInfos
  }

  func selectedDateInfo(index: Int) -> DateInfo? {
    return dateInfos[index]
  }

  private func formatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd-EEEE"
    return dateFormatter
  }

  private func dayOfWeekFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
  }

  private func dayFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd"
    return dateFormatter
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
      return "일"
    case .monday:
      return "월"
    case .tuesday:
      return "화"
    case .wednesday:
      return "수"
    case .thursday:
      return "목"
    case .friday:
      return "금"
    case .saturday:
      return "토"
    }
  }

  var weekday: Int {
    switch self {
    case .sunday:
      return 0
    case .monday:
      return 1
    case .tuesday:
      return 2
    case .wednesday:
      return 3
    case .thursday:
      return 4
    case .friday:
      return 5
    case .saturday:
      return 6
    }
  }
}
