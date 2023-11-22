//
//  WorkoutType.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct WorkoutType: Hashable {
  let workoutIcon: String
  let workoutIconDescription: String
  let typeCode: Int
  private let id = UUID()

  init(workoutIcon: String, workoutIconDescription: String, typeCode: Int) {
    self.workoutIcon = workoutIcon
    self.workoutIconDescription = workoutIconDescription
    self.typeCode = typeCode
  }

  init(workoutTypesDTO dto: WorkoutTypeDTO) {
    workoutIcon = dto.icon
    workoutIconDescription = dto.description
    typeCode = dto.typeCode
  }
}
