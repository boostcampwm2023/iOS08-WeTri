//
//  LoginCoordinator.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Keychain
import UIKit

final class LoginCoordinator: LoginCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .login

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let authorizeUseCase = AuthorizeUseCase(
      authorizationRepository: AuthorizationRepository(session: URLSession.shared),
      keychainRepository: KeychainRepository(keychain: Keychain.shared)
    )
    let loginViewModel = LoginViewModel(authorizeUseCase: authorizeUseCase)
    let viewController = LoginViewController(viewModel: loginViewModel)

    navigationController.pushViewController(viewController, animated: false)
  }
}
