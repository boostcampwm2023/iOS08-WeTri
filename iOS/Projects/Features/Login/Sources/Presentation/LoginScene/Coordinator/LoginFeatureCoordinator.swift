//
//  LoginFeatureCoordinator.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Coordinator
import Keychain
import Log
import Trinet
import UIKit

// MARK: - LoginFeatureFinishDelegate

public protocol LoginFeatureFinishDelegate: AnyObject {
  func loginFeatureCoordinatorDidFinished(initialUser: InitialUser?, token: Token?)
}

// MARK: - LoginFeatureCoordinator

public final class LoginFeatureCoordinator: LoginFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public weak var loginFeatureFinishDelegate: LoginFeatureFinishDelegate?
  public var flow: CoordinatorFlow = .login

  private let isMockEnvironment: Bool
  private let isMockFirst: Bool

  public init(
    navigationController: UINavigationController,
    isMockEnvironment: Bool,
    isMockFirst: Bool
  ) {
    self.navigationController = navigationController
    self.isMockEnvironment = isMockEnvironment
    self.isMockFirst = isMockFirst
  }

  public func start() {
    showLoginFlow()
  }

  public func showLoginFlow() {
    guard let jsonPath = isMockFirst ?
      Bundle(for: Self.self).path(forResource: "InitialUser", ofType: "json") : Bundle(for: Self.self).path(forResource: "Token", ofType: "json"),
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

    navigationController.setViewControllers([viewController], animated: true)
  }

  public func finishLogin(initialUser: InitialUser? = nil, token: Token? = nil) {
    finish()
    loginFeatureFinishDelegate?.loginFeatureCoordinatorDidFinished(initialUser: initialUser, token: token)
  }
}
