//
//  DateProvideUsecaseRepresentable.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/22.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

protocol DateProvideUsecaseRepresentable {
  func today() -> Date
  func transform(date: Date) -> DateInfo
}
