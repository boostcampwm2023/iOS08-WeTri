//
//  SplashCoordinator.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Log
import UIKit

// MARK: - SplashCoordinatorFinishDelegate

public protocol SplashCoordinatorFinishDelegate: AnyObject {
  func splashCoordinatorDidFinished(hasTokenExpired: Bool)
}

// MARK: - SplashCoordinator

public final class SplashCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private weak var splashCoordinatorFinishDelegate: SplashCoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .splash

  deinit {
    Log.make().debug("\(Self.self) deinitialized")
  }

  public init(
    navigationController: UINavigationController,
    finishDelegate: CoordinatorFinishDelegate?,
    splashCoordinatorFinishDelegate: SplashCoordinatorFinishDelegate?
  ) {
    self.navigationController = navigationController
    self.finishDelegate = finishDelegate
    self.splashCoordinatorFinishDelegate = splashCoordinatorFinishDelegate
  }

  public func start() {
    let session = URLSession.shared
    let repository = SplashTokenRepository(session: session)
    let persistencyRepository = PersistencyRepository()
    let useCase = SplashUseCase(repository: repository, persistencyRepository: persistencyRepository)
    let viewModel = SplashViewModel(coordinator: self, useCase: useCase)
    let viewController = SplashViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: false)
  }
}

// MARK: SplashCoordinating

extension SplashCoordinator: SplashCoordinating {
  func showLoginOrMainFlow(when tokenExpired: Bool) {
    finish()
    splashCoordinatorFinishDelegate?.splashCoordinatorDidFinished(hasTokenExpired: tokenExpired)
  }
}
