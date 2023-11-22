//
//  RecordUpdateUsecase.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - RecordUpdateUsecase

protocol RecordUpdateUsecase {
  func execute(dateInfo: DateInfo) -> AnyPublisher<[Record], Error>
}

// MARK: - RecordUpdateUsecaseError

enum RecordUpdateUsecaseError: Error {
  case noRecord
}

// MARK: LocalizedError

extension RecordUpdateUsecaseError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .noRecord:
      "기록이 없습니다."
    }
  }
}
