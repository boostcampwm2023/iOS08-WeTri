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
    pushWorkoutSelectViewController()
  }

  func pushWorkoutSelectViewController() {
    let workoutSelectViewController = WorkoutSelectViewController()
    navigationController.pushViewController(workoutSelectViewController, animated: false)
  }

  func pushWorkoutEnvironmentSetupViewController(workoutSetting _: WorkoutSetting) {
    // TODO: WorkoutEnvironmentSetupViewController의 Usecase에 workoutSetting 객체를 전달해줘야한다.
    
    let syringe = WorkOutEnvironmentSetupSyringe()
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
        register(T.self)
      }

      return dependencies[key] as! T
    }

    func fillUp() {
      register(WorkoutEnvironmentSetupViewModel())
      register(WorkoutEnvironmentSetupViewController(viewModel: resolve()))
    }
  }
}
