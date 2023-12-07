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
  weak var loginFinishDelegate: LoginDidFinishedDelegate?
  var flow: CoordinatorFlow = .login

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let authorizeUseCase = AuthorizeUseCase(
      authorizationRepository: AuthorizationRepository(session: URLSession.shared),
      keychainRepository: KeychainRepository(keychain: Keychain.shared)
    )
    let loginViewModel = LoginViewModel(coordinator: self, authorizeUseCase: authorizeUseCase)
    let viewController = LoginViewController(viewModel: loginViewModel)

    navigationController.pushViewController(viewController, animated: false)
  }

  func finish(initialUser: InitialUser? = nil, token: Token? = nil) {
    loginFinishDelegate?.loginCoordinatorDidFinished(initialUser: initialUser, token: token)
    finishDelegate?.flowDidFinished(childCoordinator: self)
  }
}
