//
//  DateFormatUseCase.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - DateFormatUseCaseRepresentable

protocol DateFormatUseCaseRepresentable {
  func formatyyyyMMdd(date: Date) -> String
}

// MARK: - DateFormatUseCase

final class DateFormatUseCase: DateFormatUseCaseRepresentable {
  func formatyyyyMMdd(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd-"
    return dateFormatter.string(from: date)
  }
}
