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
  /// 서버로부터 [Record]를 가져오는 로직
  func fetchRecordsList(date: Date) -> AnyPublisher<[Record], Error>

  /// 메모리와 디스크로부터 [Record]를 가져오는 로직
  func fetchCachedRecords(date: Date) -> AnyPublisher<[Record], Error>
}
