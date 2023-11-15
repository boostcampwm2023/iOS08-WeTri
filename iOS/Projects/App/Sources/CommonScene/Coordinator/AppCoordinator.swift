//
//  AppCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

final class AppCoordinator: AppCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating]
  var finishDelegate: CoordinatorFinishDelegate
  var flow: CoordinatorFlow

  init(
    navigationController: UINavigationController,
    childCoordinators: [Coordinating],
    finishDelegate: CoordinatorFinishDelegate,
    flow: CoordinatorFlow
  ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.finishDelegate = finishDelegate
    self.flow = flow
  }

  func start() {
    // (LoginFlow와 TabBarFlow 분기 처리) (todo)
  }

  func startLoginFlow() {
    // (LoginViewController 추가되면 로직 추가) (todo)
  }

  func startTabBarFlow() {
    // (TabBarController 추가되면 로직 추가) (todo)
  }
}
