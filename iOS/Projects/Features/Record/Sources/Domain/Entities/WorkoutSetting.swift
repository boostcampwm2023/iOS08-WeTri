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
  let workoutType: WorkoutMode
  let workoutPeerType: WorkoutEnvironment
  let opponents: [Opponent]
}

// MARK: - WorkoutEnvironment

enum WorkoutEnvironment {
  case single
  case multi
}

// MARK: - Opponent

struct Opponent {
  let name: String
  let distance: Int
}
