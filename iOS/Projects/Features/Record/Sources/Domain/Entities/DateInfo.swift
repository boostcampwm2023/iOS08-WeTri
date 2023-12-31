//
//  DateInfo.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - DateInfo

struct DateInfo {
  let year: String
  let month: String
  let date: String
  let dayOfWeek: String?
}

// MARK: Equatable

extension DateInfo: Equatable {
  static func == (lhs: DateInfo, rhs: DateInfo) -> Bool {
    return (lhs.year == rhs.year) && (lhs.month == rhs.month) && (lhs.date == rhs.date)
  }
}

// MARK: CustomStringConvertible

extension DateInfo: CustomStringConvertible {
  var description: String {
    return "\(year) \(month) \(date) \(dayOfWeek)"
  }
}
