//
//  LoginCoordinator.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Keychain
import Log
import Trinet
import UIKit

final class LoginCoordinator: LoginCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  weak var loginFinishDelegate: LoginDidFinishedDelegate?
  var flow: CoordinatorFlow = .login

  private let isMockEnvironment: Bool
  private let isMockFirst: Bool

  init(
    navigationController: UINavigationController,
    isMockEnvironment: Bool,
    isMockFirst: Bool
  ) {
    self.navigationController = navigationController
    self.isMockEnvironment = isMockEnvironment
    self.isMockFirst = isMockFirst
  }

  func start() {
    guard let jsonPath = isMockFirst ?
      Bundle(for: Self.self).path(forResource: "Token", ofType: "json") : Bundle(for: Self.self).path(forResource: "InitialUser", ofType: "json"),
      let jsonData = try? Data(contentsOf: .init(filePath: jsonPath))
    else {
      Log.make().error("Login Mock 데이터를 생성할 수 없습니다.")
      return
    }

    let urlSession: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockData: jsonData) : URLSession.shared

    let authorizeUseCase = AuthorizeUseCase(
      authorizationRepository: AuthorizationRepository(session: urlSession),
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
