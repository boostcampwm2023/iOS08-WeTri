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

  func execute(calendarData: CalendarData) -> AnyPublisher<[Record], Error> {
    let ymd = "\(calendarData.year)-\(calendarData.month)-\(calendarData.date)"
    return workoutRecordsRepository.fetchRecordsList(ymd: ymd)
      .flatMap { [weak self] records -> AnyPublisher<[Record], Error> in
        guard let isZero = self?.isRecordsCountZero(records: records),
              isZero
        else {
          return Just(records)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
        return Fail(outputType: [Record].self, failure: RecordUpdateUsecaseError.noRecord).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }

  private func isRecordsCountZero(records: [Record]) -> Bool {
    guard records.isEmpty else {
      return false
    }
    return true
  }
}
