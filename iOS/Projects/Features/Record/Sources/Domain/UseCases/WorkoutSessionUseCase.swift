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
import Log

// MARK: - WorkoutSessionUseCaseDependency

protocol WorkoutSessionUseCaseDependency {
  var startDate: Date { get }
  var roomID: String { get }
  var id: String { get }
  var nickname: String { get }
}

// MARK: - WorkoutSessionUseCaseRepresentable

protocol WorkoutSessionUseCaseRepresentable {
  var myHealthFormPublisher: AnyPublisher<WorkoutHealthForm, Error> { get }
  var participantsStatusPublisher: AnyPublisher<WorkoutRealTimeModel, Error> { get }
}

// MARK: - WorkoutSessionUseCase

final class WorkoutSessionUseCase {
  /// 내 운동 정보를 갖습니다.
  private let myHealthFormSubject: CurrentValueSubject<WorkoutHealthForm, Error> = .init(
    .init(distance: 0, calorie: 0, averageHeartRate: 0, minimumHeartRate: 0, maximumHeartRate: 0)
  )

  private let healthRawDataSubject: PassthroughSubject<HealthRawData, Error> = .init()

  /// 참여자의 운동 정보를 업데이트해주는 Subject입니다.
  private let participantsStatusSubject: PassthroughSubject<WorkoutRealTimeModel, Error> = .init()

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
}

extension WorkoutSessionUseCase {
  private func bind() {
    // 2초마다 Health Repository에게 데이터 요청
    Timer.publish(every: 2, on: .main, in: .common)
      .autoconnect()
      .flatMap { [healthRepository, dependency] _ in
        return healthRepository.getDistanceWalkingRunningSample(startDate: dependency.startDate).combineLatest(
          healthRepository.getCaloriesSample(startDate: dependency.startDate),
          healthRepository.getHeartRateSample(startDate: dependency.startDate)
        )
      }
      .filter {
        return !$0.isEmpty || !$1.isEmpty || !$2.isEmpty
      }
      .map(HealthRawData.init)
      .bind(to: healthRawDataSubject)
      .store(in: &subscriptions)

    // 기록할 운동 데이터를 myHealthForm에 전달
    healthRawDataSubject
      .map(calculateHealthForm)
      .bind(to: myHealthFormSubject)
      .store(in: &subscriptions)

    // 소켓으로 자신의 데이터 전달
    healthRawDataSubject
      .map(calculateWorkoutRealTimeModel)
      .flatMap(socketRepository.sendMyWorkout(with:))
      .sink { completion in
        if case let .failure(error) = completion {
          Log.make(with: .network).error("\(error)")
        }
      } receiveValue: { _ in
        // 정상적으로 전송되면 아무 일도 하지 않습니다.
      }
      .store(in: &subscriptions)

    // 참여자의 운동 정보를 실시간으로 수신
    socketRepository.fetchParticipantsRealTime()
      .bind(to: participantsStatusSubject)
      .store(in: &subscriptions)
  }

  private func calculateHealthForm(healthRawData: HealthRawData) -> WorkoutHealthForm {
    let beforeData = myHealthFormSubject.value
    let afterDistance = healthRawData.distances.reduce(beforeData.distance ?? 0, +)
    let afterCalories = healthRawData.calories.reduce(beforeData.calorie ?? 0, +)

    heartRates.append(contentsOf: heartRates)
    let averageHeartRate = heartRates.reduce(0, +) / (Double(heartRates.count) == 0 ? 1 : Double(heartRates.count))
    let minimumHeartRate = heartRates.min()
    let maximumHeartRate = heartRates.max()

    return WorkoutHealthForm(
      distance: afterDistance,
      calorie: afterCalories,
      averageHeartRate: averageHeartRate,
      minimumHeartRate: minimumHeartRate,
      maximumHeartRate: maximumHeartRate
    )
  }

  private func calculateWorkoutRealTimeModel(healthRawData: HealthRawData) -> WorkoutRealTimeModel {
    let beforeData = myHealthFormSubject.value
    let afterDistance = healthRawData.distances.reduce(beforeData.distance ?? 0, +)
    let afterCalories = healthRawData.calories.reduce(beforeData.calorie ?? 0, +)
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

extension WorkoutSessionUseCase: WorkoutSessionUseCaseRepresentable {
  var myHealthFormPublisher: AnyPublisher<WorkoutHealthForm, Error> {
    myHealthFormSubject.eraseToAnyPublisher()
  }

  var participantsStatusPublisher: AnyPublisher<WorkoutRealTimeModel, Error> {
    participantsStatusSubject.eraseToAnyPublisher()
  }
}

// MARK: - HealthRawData

private struct HealthRawData {
  let distances: [Double]
  let calories: [Double]
  let heartRates: [Double]
}
