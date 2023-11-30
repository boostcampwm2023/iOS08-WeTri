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

  private let healthRepository: HealthRepositoryRepresentable
  private let socketRepository: WorkoutSocketRepositoryRepresentable

  private var heartRates: [Double] = []

  private var subscriptions: Set<AnyCancellable> = []

  private let dependency: WorkoutSessionUseCaseDependency

  init(healthRepository: HealthRepositoryRepresentable,
       socketRepository: WorkoutSocketRepositoryRepresentable,
       dependency: WorkoutSessionUseCaseDependency) {
    self.healthRepository = healthRepository
    self.socketRepository = socketRepository
    self.dependency = dependency
    bind()
  }

  private func bind() {
    let healthDataPublisher = Timer.publish(every: 2, on: .main, in: .common)
      .autoconnect()
      .flatMap { [healthRepository, dependency] _ in
        return healthRepository.getDistanceWalkingRunningSample(startDate: dependency.date).combineLatest(
          healthRepository.getCaloriesSample(startDate: dependency.date),
          healthRepository.getHeartRateSample(startDate: dependency.date)
        ) { (distance: $0, calories: $1, heartRate: $2) }
      }

    healthDataPublisher
      .map(calculateHealthForm(distance:calories:heartRates:))
      .bind(to: myHealthFormSubject)
      .store(in: &subscriptions)

    healthDataPublisher
      .map(calculateWorkoutRealTimeModel(distance:calories:heartRates:))
      .bind(to: dataSentSubject)
      .store(in: &subscriptions)
  }

  private func calculateHealthForm(distance: [Double], calories: [Double], heartRates: [Double]) -> WorkoutHealthForm {
    let beforeData = myHealthFormSubject.value
    let afterDistance = distance.reduce(beforeData.distance ?? 0, +)
    let afterCalories = calories.reduce(beforeData.calorie ?? 0, +)

    self.heartRates.append(contentsOf: heartRates)
    let averageHeartRate = self.heartRates.reduce(0, +) / Double(self.heartRates.count)
    let minimumHeartRate = self.heartRates.min()
    let maximumHeartRate = self.heartRates.max()

    return WorkoutHealthForm(
      distance: afterDistance,
      calorie: afterCalories,
      averageHeartRate: averageHeartRate,
      minimumHeartRate: minimumHeartRate,
      maximumHeartRate: maximumHeartRate
    )
  }

  private func calculateWorkoutRealTimeModel(distance: [Double], calories: [Double], heartRates: [Double]) -> WorkoutRealTimeModel {
    let beforeData = myHealthFormSubject.value
    let afterDistance = distance.reduce(beforeData.distance ?? 0, +)
    let afterCalories = calories.reduce(beforeData.calorie ?? 0, +)
    let afterHeartRate = heartRates.last

    return .init(
      id: dependency.id,
      roomID: dependency.roomID,
      nickname: dependency.nickname,
      health: .init(
        distance: afterDistance,
        calories: afterCalories,
        heartRate: afterHeartRate
      )
    )
  }
}

// MARK: WorkoutSessionUseCaseRepresentable

extension WorkoutSessionUseCase: WorkoutSessionUseCaseRepresentable {}
