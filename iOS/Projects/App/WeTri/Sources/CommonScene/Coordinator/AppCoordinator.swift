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
    // TODO: LoginCoordinator 연결
    let aCoordinator = ACoordinator(navigationController: navigationController)
    childCoordinators.append(aCoordinator)
    aCoordinator.start()
  }

  func showTabBarFlow() {
    let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
    childCoordinators.append(tabBarCoordinator)
    tabBarCoordinator.start()
  }
}

// MARK: CoordinatorFinishDelegate

extension AppCoordinator: CoordinatorFinishDelegate {
  func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter {
      $0.flow != childCoordinator.flow
    }
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
