//
//  WorkoutRecordsRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol WorkoutRecordsRepositoryRepresentable {
  func fetchRecordsList(ymd: String) -> AnyPublisher<[Record], Error>
}
