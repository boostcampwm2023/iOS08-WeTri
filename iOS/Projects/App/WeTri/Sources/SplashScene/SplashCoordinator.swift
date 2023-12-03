//
//  SplashCoordinator.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

// MARK: - SplashCoordinatorFinishDelegate

public protocol SplashCoordinatorFinishDelegate: AnyObject {
  func splashCoordinatorDidFinished(hasTokenExpired: Bool)
}

// MARK: - SplashCoordinator

public final class SplashCoordinator: SplashCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  weak var splashCoordinatorFinishDelegate: SplashCoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .splash

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
    let viewController = SplashViewController(viewModel: SplashViewModel(coordinator: self))
    navigationController.pushViewController(viewController, animated: false)
  }
}
