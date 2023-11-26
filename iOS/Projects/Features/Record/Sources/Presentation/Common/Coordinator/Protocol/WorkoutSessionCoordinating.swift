//
//  WorkoutSessionCoordinating.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation

protocol WorkoutSessionCoordinating: Coordinating {
  /// 운동 요약 화면으로 이동합니다.
  /// - Parameter recordID: 요약 화면을 보여주기 위한 기록 Identifier
  func pushWorkoutSummaryViewController(recordID: Int)
}
