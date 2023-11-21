//
//  WorkoutSettingCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
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
    let syringe = WorkOutEnvironmentSetupSyringe()

    // TODO: WorkoutEnvironmentSetupViewController의 Usecase에 workoutSetting 객체를 전달해줘야한다.
    let workoutEnvironmentViewController: WorkoutEnvironmentSetupViewController = syringe.resolve()
    navigationController.pushViewController(workoutEnvironmentViewController, animated: false)
  }

  func pushOpponentSearchViewController(workoutSetting _: WorkoutSetting) {
    // TODO: 뷰 컨트롤러 시작 로직 작성
  }

  func pushCountdownViewController(workoutSetting _: WorkoutSetting) {
    // TODO: 뷰 컨트롤러 시작 로직 작성
  }

  func finish(workoutSetting: WorkoutSetting) {
    settingDidFinishedDelegate?.workoutSettingCoordinatorDidFinished(workoutSetting: workoutSetting)
  }
}

// MARK: WorkoutSettingCoordinator.WorkOutEnvironmentSetupSyringe

private extension WorkoutSettingCoordinator {
  class WorkOutEnvironmentSetupSyringe: Injectable {
    init() { fillUp() }

    var dependencies: [String: Any] = [:]

    func register<T>(_ dependency: T) {
      let key = String(describing: type(of: T.self))
      dependencies[key] = dependency
    }

    func resolve<T>() -> T {
      let key = String(describing: type(of: T.self))
      if dependencies[key] == nil {
        fatalError("fillup에 Dependency를 제대로 선언하세요")
      }

      return dependencies[key] as! T
    }

    func fillUp() {
      let repository = WorkoutEnvironmentSetupNetworkRepository(session: URLSession.shared)
      register(repository)

      let useCase = WorkoutEnvironmentSetupUseCase(repository: repository)
      register(useCase)

      let viewModel = WorkoutEnvironmentSetupViewModel(useCase: useCase)
      register(viewModel)

      let viewController = WorkoutEnvironmentSetupViewController(viewModel: viewModel)
      register(viewController)
    }
  }
}
