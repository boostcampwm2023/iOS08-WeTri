//
//  RecordUpdateUseCaseRepresentable.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - RecordUpdateUseCaseRepresentable

protocol RecordUpdateUseCaseRepresentable {
  func execute(date: Date) -> AnyPublisher<[Record], Error>
}

// MARK: - RecordUpdateUseCaseError

enum RecordUpdateUseCaseError: Error {
  case noRecord
}

// MARK: LocalizedError

extension RecordUpdateUseCaseError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .noRecord:
      "기록이 없습니다."
    }
  }
}
