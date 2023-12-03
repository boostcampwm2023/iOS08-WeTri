//
//  AppCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
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
    showSplashFlow()
  }

  private func showSplashFlow() {
    let splashCoordinator = SplashCoordinator(
      navigationController: navigationController,
      finishDelegate: self,
      splashCoordinatorFinishDelegate: self
    )
    childCoordinators.append(splashCoordinator)
    splashCoordinator.start()
  }

  func showOnboardingFlow() {
    let onBoardingCoordinator = OnboardingCoordinator(
      navigationController: navigationController,
      finishDelegate: self
    )
    childCoordinators.append(onBoardingCoordinator)
    onBoardingCoordinator.start()
  }

  func showLoginFlow() {
    // (LoginViewController 추가되면 로직 추가) (todo)
  }

  func showTabBarFlow() {
    // (LoginFlow와 TabBarFlow 분기 처리) (todo)
    let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
    childCoordinators.append(tabBarCoordinator)
    tabBarCoordinator.start()
  }
}

// MARK: CoordinatorFinishDelegate

extension AppCoordinator: CoordinatorFinishDelegate {
  func flowDidFinished(childCoordinator _: Coordinating) {
    // TODO: 로그아웃 Flow, 로그인 Flow (앱 실행 도중 발생되는 분기처리)
  }
}

// MARK: SplashCoordinatorFinishDelegate

extension AppCoordinator: SplashCoordinatorFinishDelegate {
  func splashCoordinatorDidFinished(hasTokenExpired: Bool) {
    if hasTokenExpired {
      showLoginFlow()
    } else {
      showTabBarFlow()
    }
  }
}
