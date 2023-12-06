//
//  SettingsCoordinator.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Log
import Trinet
import UIKit

// MARK: - SettingsCoordinator

public final class SettingsCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .profile
  private let isMockEnvironment: Bool

  public init(
    navigationController: UINavigationController,
    isMockEnvironment: Bool = false
  ) {
    self.navigationController = navigationController
    self.isMockEnvironment = isMockEnvironment
  }

  public func start() {
    let viewModel = SettingsViewModel(coordinating: self)
    let viewController = SettingsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: false)
  }
}

// MARK: SettingsCoordinating

extension SettingsCoordinator: SettingsCoordinating {
  public func moveToLogin() {}

  public func moveToProfileSettings() {}
}
