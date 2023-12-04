//
//  ProfileCoordinator.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

// MARK: - ProfileCoordinator

public final class ProfileCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .profile

  public init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
  }

  public func start() {
    let viewModel = ProfileViewModel(coordinating: self)
    let viewController = ProfileViewController(viewModel: viewModel)
    navigationController.setViewControllers([viewController], animated: false)
  }
}

// MARK: ProfileCoordinating

extension ProfileCoordinator: ProfileCoordinating {
  public func pushToSettings() {
    // TODO: 설정창으로 이동
  }
}
