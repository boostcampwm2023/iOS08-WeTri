//
//  WorkoutRecordRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/25/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol WorkoutRecordRepositoryRepresentable {
  func record(usingLocation locationData: [LocationDTO], andHealthData healthData: WorkoutHealth) -> AnyPublisher<Int, Error>
}
