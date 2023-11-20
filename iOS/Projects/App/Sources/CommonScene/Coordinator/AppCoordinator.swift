//
//  AppCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

final class AppCoordinator: AppCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .tabBar

  init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
  }

  func start() {
    // (LoginFlow와 TabBarFlow 분기 처리) (todo)
    let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
    childCoordinators.append(tabBarCoordinator)
    tabBarCoordinator.start()
  }

  func showLoginFlow() {
    // (LoginViewController 추가되면 로직 추가) (todo)
  }

  func showTabBarFlow() {
    // (TabBarController 추가되면 로직 추가) (todo)
  }
}
