//
//  HealthRepository.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import HealthKit
import Log

// MARK: - HealthRepository

public final class HealthRepository {
  private let healthStore: HKHealthStore

  private var heartRateQuery: HKQuery?
  private var distanceQuery: HKQuery?
  private var caloriesBurnedQuery: HKQuery?

  private var heartRateAnchor: HKQueryAnchor?
  private var distanceAnchor: HKQueryAnchor?
  private var caloriesAnchor: HKQueryAnchor?

  private let heartRateSubject: PassthroughSubject<Double, Never> = .init()
  private let distanceSubject: PassthroughSubject<Double, Never> = .init()
  private let caloriesSubject: PassthroughSubject<Double, Never> = .init()

  private let healthDataTypeValues: Set<HKQuantityType> = [
    HKQuantityType(.heartRate),
    HKQuantityType(.distanceWalkingRunning),
    HKQuantityType(.distanceCycling),
    HKQuantityType(.distanceSwimming),
    HKQuantityType(.activeEnergyBurned),
  ]

  // MARK: Initializations

  /// 사용자의 건강 데이터를 사용할 수 없는 경우 생성에 실패합니다.
  /// - Parameter startDate: 건강 데이터를 가져오기 위한 시작 시간
  init() {
    healthStore = .init()
    requestAuthorization()
  }

  /// 사용자에게 HealthKit 사용 인가를 요청합니다.
  private func requestAuthorization() {
    if HKHealthStore.isHealthDataAvailable() == false {
      Log.make(with: .healthKit).error("Not available HealthKit.")
      return
    }

    Log.make(with: .healthKit).notice("Requesting HealthKit authorization...")

    healthStore.requestAuthorization(toShare: nil, read: healthDataTypeValues) { _, error in
      if let error {
        Log.make(with: .healthKit).error("Received an HealthKit error type: \(error)")
      }
    }
  }

  /// HealthKit으로부터 Query를 요청하여 데이터를 받아옵니다.
  /// - Parameters:
  ///   - startDate: 요청할 데이터의 시작시점
  ///   - identifier: 요청할 데이터 타입 identifier
  ///   - anchor: 데이터를 받아올 위치, 중복되는 데이터를 설정할 때 쓰입니다.
  /// - Returns: HealthKit으로 받아온 샘플 데이터와 새로운 anchor
  private func query(startDate: Date, identifier: HKQuantityTypeIdentifier, anchor: HKQueryAnchor?) async throws -> ([HKSample]?, HKQueryAnchor?) {
    return try await withCheckedThrowingContinuation { continuation in

      let query = HKAnchoredObjectQuery(
        type: HKQuantityType(identifier),
        predicate: HKQuery.predicateForSamples(withStart: startDate, end: nil),
        anchor: anchor,
        limit: HKObjectQueryNoLimit
      ) { _, samples, _, newAnchor, error in
        Log.make(with: .healthKit).notice("\(samples ?? []), \(newAnchor)")
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: (samples, newAnchor))
        }
        guard let samples,
              samples.isEmpty == false
        else {
          Log.make(with: .healthKit).notice("\(identifier.rawValue) Samples are empty.")
          return
        }
      }

      query.updateHandler = { _, samples, _, newAnchor, _ in
        Log.make(with: .healthKit).notice("\(samples ?? []), \(newAnchor)")
        guard let samples,
              samples.isEmpty == false
        else {
          Log.make(with: .healthKit).notice("\(identifier.rawValue) Samples are empty.")
          return
        }
      }

      switch identifier {
      case .activeEnergyBurned:
        caloriesBurnedQuery = query
      case .distanceWalkingRunning:
        distanceQuery = query
      case .heartRate:
        heartRateQuery = query
      default:
        break
      }

      healthStore.execute(query)
    }
  }

  /// HKSample을 HKQuantitySample로 파싱합니다.
  private func parseToQuantitySample(samples: [HKSample]?) throws -> [HKQuantitySample] {
    guard let quantitySamples = samples as? [HKQuantitySample]
    else {
      throw HealthError.cannotParseToQuantitySample
    }
    return quantitySamples
  }

  /// 샘플을 실제 단위의 데이터로 변환합니다.
  /// - Parameters:
  ///   - samples: QuantitySample 타입의 데이터
  ///   - unit: 표기할 단위
  /// - Returns: 단위로 표기된 실제 데이터 값
  private func sampleToDoubleValue(with samples: [HKQuantitySample], unit: HKUnit) -> [Double] {
    return samples.map { $0.quantity.doubleValue(for: unit) }
  }
}

// MARK: HealthRepositoryRepresentable

extension HealthRepository: HealthRepositoryRepresentable {
  func getHeartRateSample(startDate: Date) -> AnyPublisher<[Double], Error> {
    Future<[Double], Error> { promise in
      Task { [weak self] in
        guard let self else {
          promise(.failure(HealthError.repositoryDeinitialized))
          return
        }
        do {
          // 0. healthStore에게 query 중단 요청
          if let heartRateQuery {
            healthStore.stop(heartRateQuery)
          }

          // 1. Query요청으로 샘플 데이터 수신
          let (samples, newAnchor) = try await query(startDate: startDate, identifier: .heartRate, anchor: heartRateAnchor)

          // 2. QuantitySample로 형변환
          let quantitySamples = try parseToQuantitySample(samples: samples)

          // 3. 알맞는 단위에 맞춰 값 변환
          let heartRate = sampleToDoubleValue(with: quantitySamples, unit: .init(from: "count/min"))

          // 4. promise에 전달
          promise(.success(heartRate))

          // 5. 중복 데이터를 방지하기 위해 anchor 설정
          heartRateAnchor = newAnchor

        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func getDistanceWalkingRunningSample(startDate: Date) -> AnyPublisher<[Double], Error> {
    Future<[Double], Error> { promise in
      Task { [weak self] in
        guard let self else {
          promise(.failure(HealthError.repositoryDeinitialized))
          return
        }
        do {
          // 0. healthStore에게 query 중단 요청
          if let distanceQuery {
            healthStore.stop(distanceQuery)
          }

          // 1. Query요청으로 샘플 데이터 수신
          let (samples, newAnchor) = try await query(startDate: startDate, identifier: .distanceWalkingRunning, anchor: distanceAnchor)

          // 2. QuantitySample로 형변환
          let quantitySamples = try parseToQuantitySample(samples: samples)

          // 3. 알맞는 단위에 맞춰 값 변환
          let distance = sampleToDoubleValue(with: quantitySamples, unit: .meter())

          // 4. promise에 전달
          promise(.success(distance))

          // 5. 중복 데이터를 방지하기 위해 anchor 설정
          distanceAnchor = newAnchor

        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func getCaloriesSample(startDate: Date) -> AnyPublisher<[Double], Error> {
    Future<[Double], Error> { promise in
      Task { [weak self] in
        guard let self else {
          promise(.failure(HealthError.repositoryDeinitialized))
          return
        }

        do {
          // 0. healthStore에게 query 중단 요청
          if let caloriesBurnedQuery {
            healthStore.stop(caloriesBurnedQuery)
          }

          // 1. Query요청으로 샘플 데이터 수신
          let (samples, newAnchor) = try await query(startDate: startDate, identifier: .activeEnergyBurned, anchor: caloriesAnchor)

          // 2. QuantitySample로 형변환
          let quantitySamples = try parseToQuantitySample(samples: samples)

          // 3. 알맞는 단위에 맞춰 값 변환
          let calories = sampleToDoubleValue(with: quantitySamples, unit: .init(from: "kcal"))

          // 4. promise에 전달
          promise(.success(calories))

          // 5. 중복 데이터를 방지하기 위해 anchor 설정
          caloriesAnchor = newAnchor

        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: HealthRepository.HealthError

extension HealthRepository {
  enum HealthError: LocalizedError {
    case repositoryDeinitialized
    case cannotParseToQuantitySample
  }
}
