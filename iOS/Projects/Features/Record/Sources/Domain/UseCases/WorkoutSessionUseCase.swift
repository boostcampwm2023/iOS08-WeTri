//
//  WorkoutSessionUseCase.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import Foundation

// MARK: - WorkoutSessionUseCaseDependency

struct WorkoutSessionUseCaseDependency {
  let date: Date
  let roomID: String
  let id: String
  let nickname: String
}

// MARK: - WorkoutSessionUseCaseRepresentable

protocol WorkoutSessionUseCaseRepresentable {}

// MARK: - WorkoutSessionUseCase

final class WorkoutSessionUseCase {
  private let myHealthFormSubject: CurrentValueSubject<WorkoutHealthForm, Error> = .init(.init(distance: 0, calorie: 0, averageHeartRate: 0, minimumHeartRate: 0, maximumHeartRate: 0))
  private let dataSentSubject: PassthroughSubject<WorkoutRealTimeModel, Error> = .init()
  private let repository: HealthRepositoryRepresentable

  private var heartRates: [Double] = []

  private var subscriptions: Set<AnyCancellable> = []

  private let dependency: WorkoutSessionUseCaseDependency

  init(repository: HealthRepositoryRepresentable, dependency: WorkoutSessionUseCaseDependency) {
    self.repository = repository
    self.dependency = dependency
    bind()
  }

  private func bind() {
    let healthDataPublisher = Timer.publish(every: 2, on: .main, in: .common)
      .autoconnect()
      .flatMap { [repository, dependency] _ in
        return repository.getDistanceWalkingRunningSample(startDate: dependency.date).combineLatest(
          repository.getCaloriesSample(startDate: dependency.date),
          repository.getHeartRateSample(startDate: dependency.date)
        ) { (distance: $0, calories: $1, heartRate: $2) }
      }
  }
}

// MARK: WorkoutSessionUseCaseRepresentable

extension WorkoutSessionUseCase: WorkoutSessionUseCaseRepresentable {}
