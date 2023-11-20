//
//  RecordFeatureCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

// MARK: - RecordFeatureCoordinator

public final class RecordFeatureCoordinator: RecordFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .workoutSetting
  public var recordContainerViewController: RecordContainerViewController

  public init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
    recordContainerViewController = RecordContainerViewController()
  }

  public func start() {
    navigationController.pushViewController(recordContainerViewController, animated: false)
  }

  func showSettingFlow() {
    let workoutSettingCoordinator = WorkoutSettingCoordinator(navigationController: navigationController)
    childCoordinators.append(workoutSettingCoordinator)
    workoutSettingCoordinator.finishDelegate = self
    workoutSettingCoordinator.settingDidFinishedDelegate = self
    workoutSettingCoordinator.start()
  }

  func showWorkoutFlow(workoutSetting _: WorkoutSetting) {
    let workoutCoordinator = WorkoutCoordinator(navigationController: navigationController)
    childCoordinators.append(workoutCoordinator)
    workoutCoordinator.finishDelegate = self
    workoutCoordinator.start()
  }
}

// MARK: CoordinatorFinishDelegate

extension RecordFeatureCoordinator: CoordinatorFinishDelegate {
  public func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter {
      $0.flow != childCoordinator.flow
    }
    navigationController.popToRootViewController(animated: false)
  }
}

// MARK: WorkoutSettingCoordinatorFinishDelegate

extension RecordFeatureCoordinator: WorkoutSettingCoordinatorFinishDelegate {
  func workoutSettingCoordinatorDidFinished(workoutSetting: WorkoutSetting) {
    showWorkoutFlow(workoutSetting: workoutSetting)
  }
}
