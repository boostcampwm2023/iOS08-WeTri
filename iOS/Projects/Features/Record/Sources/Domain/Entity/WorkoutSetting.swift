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
  let mode: WorkoutMode
  let environment: WorkoutEnvironment
  let opponents: [Opponent]
}

// MARK: - WorkoutMode

enum WorkoutMode {
  case run
  case swim
  case cycle
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
