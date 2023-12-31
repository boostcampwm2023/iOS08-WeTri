//
//  WorkoutEnvironmentSetUpCoordinating.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation

protocol WorkoutEnvironmentSetUpCoordinating: Coordinating {
  func pushWorkoutSelectViewController()
  func pushWorkoutEnvironmentSetupViewController()
  func pushPeerRandomMatchingViewController(workoutSetting: WorkoutSetting)
  func finish(workoutSessionComponents: WorkoutSessionComponents)
  func popPeerRandomMatchingViewController()
}
