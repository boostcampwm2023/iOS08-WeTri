//
//  AppCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Coordinator
import LoginFeature
import OnboardingFeature
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
      onboardingFinishDelegate: self
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
    coordinator.loginFeatureFinishDelegate = self
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
    coordinator.signUpFeatureFinishDelegate = self
    coordinator.start()
  }

  func showTabBarFlow() {
    navigationController.isNavigationBarHidden = true
    let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, tabBarFinishDelegate: self)
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

// MARK: SignUpFeatureCoordinatorFinishDelegate

extension AppCoordinator: SignUpFeatureCoordinatorFinishDelegate {
  func signUpFeatureCoordinatorDidFinished() {
    showOnboardingFlow()
  }
}

// MARK: LoginFeatureFinishDelegate

extension AppCoordinator: LoginFeatureFinishDelegate {
  func loginFeatureCoordinatorDidFinished(initialUser: InitialUser?, token: Token?) {
    if let initialUser {
      showSignUpFlow(
        newUserInformation: NewUserInformation(
          mappedUserID: initialUser.mappedUserID,
          provider: initialUser.provider
        )
      )
    }

    if token != nil {
      showTabBarFlow()
    }
  }
}

// MARK: TabBarFinishDelegate

extension AppCoordinator: TabBarFinishDelegate {
  func moveToLogin() {
    showLoginFlow()
  }
}

// MARK: OnboardingFinishDelegate

extension AppCoordinator: OnboardingFinishDelegate {
  func finishOnboarding() {
    showTabBarFlow()
    childCoordinators = childCoordinators.filter { $0.flow != .onboarding }
  }
}
