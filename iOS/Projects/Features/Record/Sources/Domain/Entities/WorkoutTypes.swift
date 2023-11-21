//
//  WorkoutTypes.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct WorkoutTypes {
  let workoutIcon: String
  let workoutIconDescription: String

  init(workoutIcon: String, workoutIconDescription: String) {
    self.workoutIcon = workoutIcon
    self.workoutIconDescription = workoutIconDescription
  }

  init(workoutTypesDTO dto: WorkoutTypeDTO) {
    workoutIcon = dto.icon
    workoutIconDescription = dto.description
  }
}
