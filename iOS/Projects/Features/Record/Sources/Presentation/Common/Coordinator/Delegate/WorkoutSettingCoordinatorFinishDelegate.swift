//
//  WorkoutSettingCoordinatorFinishDelegate.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

protocol WorkoutSettingCoordinatorFinishDelegate: AnyObject {
  func workoutSettingCoordinatorDidFinished(workoutSessionComponents: WorkoutSessionComponents)
}
