//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation
import UIKit

// MARK: - HomeCoordinating

public protocol HomeCoordinating: Coordinating {
  func pushHome()
}

// MARK: - HomeCoordinator

public final class HomeCoordinator: HomeCoordinating {
  public var navigationController: UINavigationController

  public var childCoordinators: [Coordinator.Coordinating] = []

  public var finishDelegate: CoordinatorFinishDelegate?

  public var flow: CoordinatorFlow
  public init(navigationController: UINavigationController, delegate: CoordinatorFinishDelegate) {
    self.navigationController = navigationController
    finishDelegate = delegate
    flow = .login
  }

  public func start() {
    pushHome()
  }

  public func pushHome() {
    let viewModel = HomeViewModel()

    let viewController = HomeViewController(viewModel: viewModel)

    navigationController.pushViewController(viewController, animated: true)
  }

  public func pushBoardDetail() {}
}
