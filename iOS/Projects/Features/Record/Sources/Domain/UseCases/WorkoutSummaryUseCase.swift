//
//  WorkoutSummaryUseCase.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/22/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutSummaryUseCaseRepresentable

protocol WorkoutSummaryUseCaseRepresentable {
  func workoutSummaryInformation() -> AnyPublisher<WorkoutSummaryModel, Error>
}

// MARK: - WorkoutSummaryUseCase

struct WorkoutSummaryUseCase {
  private let repository: WorkoutSummaryRepositoryRepresentable
  private let workoutRecordID: Int

  init(repository: WorkoutSummaryRepositoryRepresentable, workoutRecordID: Int) {
    self.repository = repository
    self.workoutRecordID = workoutRecordID
  }
}

// MARK: WorkoutSummaryUseCaseRepresentable

extension WorkoutSummaryUseCase: WorkoutSummaryUseCaseRepresentable {
  func workoutSummaryInformation() -> AnyPublisher<WorkoutSummaryModel, Error> {
    repository.fetchWorkoutSummary(with: workoutRecordID)
  }
}
