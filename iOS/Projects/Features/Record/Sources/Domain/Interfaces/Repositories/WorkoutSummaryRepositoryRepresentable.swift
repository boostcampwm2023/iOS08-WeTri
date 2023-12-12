//
//  WorkoutSummaryRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/22/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutSummaryRepositoryRepresentable

protocol WorkoutSummaryRepositoryRepresentable {
  /// 운동 요약 데이터를 가져옵니다.
  /// - Parameter id: 운동 데이터의 고유 Identifier 값
  func fetchWorkoutSummary(with id: Int) -> AnyPublisher<WorkoutSummaryModel, Error>
}
