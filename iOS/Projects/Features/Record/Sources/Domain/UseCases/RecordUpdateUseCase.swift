//
//  RecordUpdateUseCase.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

final class RecordUpdateUseCase: RecordUpdateUseCaseRepresentable {
  private let workoutRecordsRepository: WorkoutRecordsRepositoryRepresentable

  init(workoutRecordsRepository: WorkoutRecordsRepositoryRepresentable) {
    self.workoutRecordsRepository = workoutRecordsRepository
  }

  func execute(date: Date) -> AnyPublisher<[Record], Error> {
    return workoutRecordsRepository.fetchRecordsList(date: date)
      .flatMap { records -> AnyPublisher<[Record], Error> in
        guard records.isEmpty else {
          return Just(records)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
        return Fail(error: RecordUpdateUseCaseError.noRecord)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
