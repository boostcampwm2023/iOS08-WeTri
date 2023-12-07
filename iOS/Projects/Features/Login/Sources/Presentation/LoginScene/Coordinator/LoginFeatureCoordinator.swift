//
//  LoginFeatureCoordinator.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Keychain
import SignUpFeature
import UIKit

// MARK: - LoginFeatureCoordinator

public final class LoginFeatureCoordinator: LoginFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .login

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start() {
    showLoginFlow()
  }

  func showLoginFlow() {
    let coordinator = LoginCoordinator(
      navigationController: navigationController,
      isMockEnvironment: true,
      isMockFirst: true
    )
    childCoordinators.append(coordinator)
    coordinator.finishDelegate = self
    coordinator.loginFinishDelegate = self
    coordinator.start()
  }
}

// MARK: CoordinatorFinishDelegate

extension LoginFeatureCoordinator: CoordinatorFinishDelegate {
  public func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter {
      $0.flow != childCoordinator.flow
    }
  }
}

// MARK: LoginDidFinishedDelegate

extension LoginFeatureCoordinator: LoginDidFinishedDelegate {
  func loginCoordinatorDidFinished(initialUser: InitialUser?, token: Token?) {
    if let initialUser {
      let coordinator = SignUpFeatureCoordinator(
        navigationController: navigationController,
        newUserInformation: NewUserInformation(
          mappedUserID: initialUser.mappedUserID,
          provider: .apple
        )
      )
      childCoordinators.append(coordinator)
      coordinator.finishDelegate = self
      coordinator.showSignUpFlow()
    }

    // TODO: User가 처음이 아니라면 토큰이 존재한다 해당 토큰 갖고 TabBar로 넘어가야됨.
    if let token {}
  }
}
