//
//  AppCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import LoginFeature
import UIKit

// MARK: - AppCoordinator

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
    showLoginFlow()
//    let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
//    childCoordinators.append(tabBarCoordinator)
//    tabBarCoordinator.start()
  }

  func showLoginFlow() {
    let loginCoordinator = LoginCoordinator(navigationController: navigationController)
    childCoordinators.append(loginCoordinator)
    loginCoordinator.finishDelegate = self
    loginCoordinator.start()
  }

  func showTabBarFlow() {
    // (TabBarController 추가되면 로직 추가) (todo)
  }
}

// MARK: CoordinatorFinishDelegate

extension AppCoordinator: CoordinatorFinishDelegate {
  func flowDidFinished(childCoordinator _: Coordinating) {
    // TODO: 로그아웃 Flow, 로그인 Flow (앱 실행 도중 발생되는 분기처리)
  }
}
