//
//  LoginFeatureCoordinator.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Keychain
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
    let authorizeUseCase = AuthorizeUseCase(
      authorizationRepository: AuthorizationRepository(session: URLSession.shared),
      keychainRepository: KeychainRepository(keychain: Keychain.shared)
    )
    let loginViewModel = LoginViewModel(authorizeUseCase: authorizeUseCase)
    let viewController = LoginViewController(viewModel: loginViewModel)

    navigationController.pushViewController(viewController, animated: false)
  }
}

// MARK: CoordinatorFinishDelegate

extension LoginFeatureCoordinator: CoordinatorFinishDelegate {
  public func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter {
      $0.flow != childCoordinator.flow
    }
    navigationController.popToRootViewController(animated: false)
  }
}
