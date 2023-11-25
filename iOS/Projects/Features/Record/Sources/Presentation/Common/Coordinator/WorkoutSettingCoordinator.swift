//
//  WorkoutSettingCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Trinet
import UIKit

// MARK: - WorkoutSettingCoordinator

final class WorkoutSettingCoordinator: WorkoutSettingCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .workoutSetting
  weak var settingDidFinishedDelegate: WorkoutSettingCoordinatorFinishDelegate?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    pushWorkoutEnvironmentSetupViewController()
  }

  func pushWorkoutSelectViewController() {
    let workoutSelectViewController = WorkoutSelectViewController()
    navigationController.pushViewController(workoutSelectViewController, animated: false)
  }

  func pushWorkoutEnvironmentSetupViewController() {
    let repository = WorkoutEnvironmentSetupNetworkRepository(session: URLSession.shared)

    let useCase = WorkoutEnvironmentSetupUseCase(repository: repository)

    let viewModel = WorkoutEnvironmentSetupViewModel(useCase: useCase, coordinator: self)

    let viewController = WorkoutEnvironmentSetupViewController(viewModel: viewModel)

    navigationController.pushViewController(viewController, animated: false)
  }

  func pushPeerRandomMatchingViewController(workoutSetting _: WorkoutSetting) {
    let viewModel = WorkoutPeerRandomMatchingViewModel(coordinating: self)

    let viewController = WorkoutPeerRandomMatchingViewController(viewModel: viewModel)

    viewController.modalPresentationStyle = .overFullScreen
    viewController.modalTransitionStyle = .crossDissolve
    navigationController.present(viewController, animated: true)
    // TODO: 뷰 컨트롤러 시작 로직 작성
  }

  func popPeerRandomMatchingViewController() {
    navigationController.dismiss(animated: true)
  }

  func pushCountdownViewController(workoutSetting _: WorkoutSetting) {
    // TODO: 뷰 컨트롤러 시작 로직 작성
  }

  func finish(workoutSetting: WorkoutSetting) {
    settingDidFinishedDelegate?.workoutSettingCoordinatorDidFinished(workoutSetting: workoutSetting)
  }
}
