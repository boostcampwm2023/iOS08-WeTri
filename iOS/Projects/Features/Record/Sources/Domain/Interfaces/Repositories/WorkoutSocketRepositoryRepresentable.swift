//
//  WorkoutSocketRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol WorkoutSocketRepositoryRepresentable {
  /// 참여자의 실시간 운동 정보를 가져옵니다.
  func fetchParticipantsRealTime() -> AnyPublisher<WorkoutRealTimeModel, Error>

  /// 나의 운동 정보를 전달합니다.
  func sendMyWorkout(with model: WorkoutRealTimeModel) -> AnyPublisher<Void, Error>
}
