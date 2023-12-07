//
//  WorkoutRecordUseCase.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/25/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutRecordUseCaseRepresentable

protocol WorkoutRecordUseCaseRepresentable {
  func record(dataForm: WorkoutDataForm) -> AnyPublisher<Int, Error>
}

// MARK: - WorkoutRecordUseCase

struct WorkoutRecordUseCase {
  private let repository: WorkoutRecordRepositoryRepresentable

  init(repository: WorkoutRecordRepositoryRepresentable) {
    self.repository = repository
  }
}

// MARK: WorkoutRecordUseCaseRepresentable

extension WorkoutRecordUseCase: WorkoutRecordUseCaseRepresentable {
  func record(dataForm: WorkoutDataForm) -> AnyPublisher<Int, Error> {
    repository.record(dataForm: dataForm)
  }
}
