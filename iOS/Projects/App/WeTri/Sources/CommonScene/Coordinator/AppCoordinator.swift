//
//  AppCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import LoginFeature
import SignUpFeature
import SplashFeature
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
    showLoginFlow()
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
    let coordinator = LoginFeatureCoordinator(
      navigationController: navigationController,
      isMockEnvironment: false,
      isMockFirst: true
    )
    childCoordinators.append(coordinator)
    coordinator.finishDelegate = self
    coordinator.start()
  }

  func showSignUpFlow(newUserInformation: NewUserInformation) {
    let coordinator = SignUpFeatureCoordinator(
      navigationController: navigationController,
      newUserInformation: newUserInformation,
      isMockEnvironment: false
    )
    childCoordinators.append(coordinator)
    coordinator.finishDelegate = self
    coordinator.start()
  }

  func showTabBarFlow() {
    navigationController.isNavigationBarHidden = true
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
    navigationController.popToRootViewController(animated: false)
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

// MARK: SignUpFeatureCoordinatorFinishDelegate

extension AppCoordinator: SignUpFeatureCoordinatorFinishDelegate {
  func signUpFeatureCooridnatorDidFinished() {
    showTabBarFlow()
  }
}

// MARK: LoginFeatureFinishDelegate

extension AppCoordinator: LoginFeatureFinishDelegate {
  func loginFeatureCoordinatorDidFinished(initialUser: InitialUser?, token: Token?) {
    if let initialUser {
      // TODO: 처음접속하는 유저일 경우 signUp
      showSignUpFlow(newUserInformation: NewUserInformation(
        mappedUserID: initialUser.mappedUserID,
        provider: initialUser.provider
      )
      )
    }

    if let token {
      // TODO: 기존에 접속해본적이 있어서 로그인하고 토큰을 받은 경우
    }
  }
}
