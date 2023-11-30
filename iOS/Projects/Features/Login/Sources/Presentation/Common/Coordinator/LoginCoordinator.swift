//
//  LoginCoordinator.swift
//  LoginFeature
//
//  Created by 안종표 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Keychain
import UIKit

public final class LoginCoordinator: LoginCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .login

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start() {
    pushLoginViewController()
  }

  public func pushLoginViewController() {
    let authorizationRepository = AuthorizationRepository(session: URLSession.shared)
    let keychainRepository = KeychainRepository(keychain: Keychain.shared)
    let authorizeUseCase = AuthorizeUseCase(
      authorizationRepository: authorizationRepository,
      keychainRepository: keychainRepository
    )
    let viewModel = LoginViewModel(authorizeUseCase: authorizeUseCase)
    let viewController = LoginViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: false)
  }
}
