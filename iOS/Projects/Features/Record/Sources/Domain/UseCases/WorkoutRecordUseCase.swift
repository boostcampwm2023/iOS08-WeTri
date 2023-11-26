//
//  WorkoutRecordUseCase.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/25/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
// MARK: - WorkoutSummaryUseCaseRepresentable

protocol WorkoutRecordUseCaseRepresentable {
  func record(locations: [LocationDTO], healthData: WorkoutHealth) -> AnyPublisher<Int, Error>
}

// MARK: - WorkoutSummaryUseCase

struct WorkoutRecordUseCase {
  private let repository: WorkoutRecordRepositoryRepresentable

  init(repository: WorkoutRecordRepositoryRepresentable) {
    self.repository = repository
  }
}

// MARK: WorkoutSummaryUseCaseRepresentable

extension WorkoutRecordUseCase: WorkoutRecordUseCaseRepresentable {
  func record(locations: [LocationDTO], healthData: WorkoutHealth) -> AnyPublisher<Int, Error> {
    repository.record(usingLocation: locations, andHealthData: healthData)
  }
}
