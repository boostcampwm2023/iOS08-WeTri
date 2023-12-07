//
//  SignUpFeatureCoordinator.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

// MARK: - SignUpFeatureCoordinator

public final class SignUpFeatureCoordinator: SignUpFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .signup

  private let userBit: UserBit

  public init(
    navigationController: UINavigationController,
    userBit: UserBit
  ) {
    self.navigationController = navigationController
    self.userBit = userBit
  }

  public func start() {
    showSignUpFlow()
  }

  public func showSignUpFlow() {
    let coordinator = SignUpCoordinator(navigationController: navigationController, isMockEnvironment: true, userBit: userBit)
    childCoordinators.append(coordinator)
    coordinator.finishDelegate = self
    coordinator.start()
  }
}

// MARK: CoordinatorFinishDelegate

extension SignUpFeatureCoordinator: CoordinatorFinishDelegate {
  public func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter {
      $0.flow != childCoordinator.flow
    }
  }
}
