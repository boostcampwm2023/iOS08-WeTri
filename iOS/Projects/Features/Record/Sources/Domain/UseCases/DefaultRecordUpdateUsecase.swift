//
//  DefaultRecordUpdateUsecase.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

final class DefaultRecordUpdateUsecase: RecordUpdateUsecase {
  private let workoutRecordsRepository: WorkoutRecordsRepository

  init(workoutRecordsRepository: WorkoutRecordsRepository) {
    self.workoutRecordsRepository = workoutRecordsRepository
  }

  func execute(dateInfo: DateInfo) -> AnyPublisher<[Record], Error> {
    let ymd = "\(dateInfo.year)-\(dateInfo.month)-\(dateInfo.date)"
    return workoutRecordsRepository.fetchRecordsList(ymd: ymd)
      .flatMap { records -> AnyPublisher<[Record], Error> in
        guard records.isEmpty else {
          return Just(records)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
        return Fail(outputType: [Record].self, failure: RecordUpdateUsecaseError.noRecord).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
