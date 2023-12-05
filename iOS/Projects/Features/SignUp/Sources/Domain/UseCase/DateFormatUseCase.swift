//
//  DateFormatUseCase.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - DateFormatUseCaseRepresentable

public protocol DateFormatUseCaseRepresentable {
  func formatyyyyMMdd(date: Date) -> String
}

// MARK: - DateFormatUseCase

public final class DateFormatUseCase: DateFormatUseCaseRepresentable {
  public init() {}

  public func formatyyyyMMdd(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
  }
}
