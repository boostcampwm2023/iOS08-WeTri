//
//  ProfileCoordinator.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Trinet
import UIKit

// MARK: - ProfileCoordinator

public final class ProfileCoordinator {
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
    let session: URLSessionProtocol = isMockEnvironment ? MockURLSession() : URLSession.shared
    let repository = ProfileRepository(session: session)
    let useCase = ProfileUseCase(repository: repository)
    let viewModel = ProfileViewModel(coordinating: self, useCase: useCase)
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
