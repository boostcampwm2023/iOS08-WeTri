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

  func execute(calendarData: CalendarData) -> AnyPublisher<[Record], Never> {
    let ymd = "\(calendarData.year)-\(calendarData.month)-\(calendarData.date)"

    return workoutRecordsRepository.fetchRecordsList(ymd: ymd)
      .eraseToAnyPublisher()
  }
}
