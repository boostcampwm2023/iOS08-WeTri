//
//  HealthRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol HealthRepositoryRepresentable {
  func getHeartRateSample(startDate: Date, duplicate: Bool) -> AnyPublisher<[Double], Error>
  func getDistanceWalkingRunningSample(startDate: Date, duplicate: Bool) -> AnyPublisher<[Double], Error>
  func getCaloriesSample(startDate: Date, duplicate: Bool) -> AnyPublisher<[Double], Error>
}
