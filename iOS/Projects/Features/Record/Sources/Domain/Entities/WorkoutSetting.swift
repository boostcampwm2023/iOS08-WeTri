//
//  WorkoutSetting.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - WorkoutSetting

struct WorkoutSetting {
  let workoutType: WorkoutType
  let workoutPeerType: PeerType
  let isWorkoutAlone: Bool
  init(workoutType: WorkoutType, workoutPeerType: PeerType, isWorkoutAlone: Bool = true) {
    self.workoutType = workoutType
    self.workoutPeerType = workoutPeerType
    self.isWorkoutAlone = isWorkoutAlone
  }
}
