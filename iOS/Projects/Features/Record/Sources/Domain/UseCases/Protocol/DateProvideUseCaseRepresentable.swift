//
//  DateProvideUseCaseRepresentable.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/22.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

protocol DateProvideUseCaseRepresentable {
  func today() -> Date
  func todayIndex(sectionCount: Int) -> IndexPath
  func transform(date: Date) -> DateInfo
  func transform(dateInfo: DateInfo) -> Date?
  func fetchAllDatesThisMonth() -> [DateInfo]
  func selectedDateInfo(index: Int) -> DateInfo?
}
