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

// MARK: - WorkoutSessionUseCaseRepresentable

protocol WorkoutSessionUseCaseRepresentable {
  var healthPublisher: AnyPublisher<(distance: Double, calories: Double, heartRate: Double), Error> { get }
}

// MARK: - WorkoutSessionUseCase

final class WorkoutSessionUseCase {
  private let healthPassthroughSubject: CurrentValueSubject<(distance: Double, calories: Double, heartRate: Double), Error> = .init((0, 0, 0))
  private let repository: HealthRepositoryRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // TODO: 서버로부터 받은 데이트 타입으로 설정할 필요
  private let date: Date = .now

  init(repository: HealthRepositoryRepresentable) {
    self.repository = repository
    bind()
  }

  private func bind() {
    let distancePublisher = repository.getDistanceWalkingRunningSample(startDate: date)
    let caloriesPublisher = repository.getCaloriesSample(startDate: date)
    let heartRatePublisher = repository.getHeartRateSample(startDate: date)

    let combinedHealthDataPublisher = distancePublisher.combineLatest(caloriesPublisher, heartRatePublisher) {
      (distance: $0, calories: $1, heartRate: $2)
    }

    Timer.publish(every: 2, on: .main, in: .common)
      .autoconnect()
      .flatMap { _ in
        combinedHealthDataPublisher
      }
      .compactMap { [weak self] distance, calories, heartRate in
        guard let self else { return nil }
        let (beforeDistance, beforeCalories, beforeHeartRate) = healthPassthroughSubject.value
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
