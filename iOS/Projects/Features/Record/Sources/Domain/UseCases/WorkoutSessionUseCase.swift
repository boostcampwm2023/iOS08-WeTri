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

struct WorkoutSessionUseCaseDependency {
  let date: Date
}

// MARK: - WorkoutSessionUseCaseRepresentable

protocol WorkoutSessionUseCaseRepresentable {
  var healthPublisher: AnyPublisher<(distance: Double, calories: Double, heartRate: Double), Error> { get }
}

// MARK: - WorkoutSessionUseCase

final class WorkoutSessionUseCase {
  private let healthPassthroughSubject: CurrentValueSubject<WorkoutRealTimeModel, Error> = .init(.init(id: "", roomID: "", nickname: "", health: .init(distance: 0, calories: 0, heartRate: 0)))
  private let repository: HealthRepositoryRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // TODO: 서버로부터 받은 데이트 타입으로 설정할 필요
  private let dependency: WorkoutSessionUseCaseDependency

  init(repository: HealthRepositoryRepresentable, dependency: WorkoutSessionUseCaseDependency) {
    self.repository = repository
    self.dependency = dependency
    bind()
  }

  private func bind() {
    Timer.publish(every: 2, on: .main, in: .common)
      .autoconnect()
      .flatMap { [weak self] _ in
        guard let self
        else {
          return Just(([0.0], [0.0], [0.0])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return repository.getDistanceWalkingRunningSample(startDate: dependency.date).combineLatest(
          repository.getCaloriesSample(startDate: dependency.date),
          repository.getHeartRateSample(startDate: dependency.date)
        ) {
          (distance: $0, calories: $1, heartRate: $2)
        }
        .eraseToAnyPublisher()
      }
      .compactMap { [weak self] distance, calories, heartRate in
        guard let self else { return nil }
        let beforeData = healthPassthroughSubject.value
        let afterDistance = distance.reduce(beforeDistance, +)
        let afterCalories = calories.reduce(beforeCalories, +)
        let afterHeartRate = heartRate.last ?? beforeHeartRate
        return (distance: afterDistance, calories: afterCalories, heartRate: afterHeartRate)
      }
      .bind(to: healthPassthroughSubject)
      .store(in: &subscriptions)
  }
}

// MARK: WorkoutSessionUseCaseRepresentable

extension WorkoutSessionUseCase: WorkoutSessionUseCaseRepresentable {
  var healthPublisher: AnyPublisher<(distance: Double, calories: Double, heartRate: Double), Error> {
    healthPassthroughSubject.eraseToAnyPublisher()
  }
}
