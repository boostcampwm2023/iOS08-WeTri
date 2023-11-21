//
//  WorkoutCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

final class WorkoutCoordinator: WorkoutCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .workout

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    pushWorkoutSummaryViewController()
  }

  func pushWorkoutSummaryViewController() {
    let workoutSummaryViewController = WorkoutSummaryViewController(
      viewModel: WorkoutSummaryViewModel()
    )
    navigationController.pushViewController(workoutSummaryViewController, animated: false)
  }

  func pushWorkoutMapViewController() {
    // TODO: 뷰 컨트롤러 시작 로직 작성
  }

  func pushWorkoutResultViewController() {
    // TODO: 뷰 컨트롤러 시작 로직 작성
  }
}
