//
//  ProfileCoordinator.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Keychain
import Log
import Trinet
import UIKit
import WriteBoardFeature

// MARK: - ProfileFinishFinishDelegate

public protocol ProfileFinishFinishDelegate: AnyObject {
  func moveToLogin()
}

// MARK: - ProfileCoordinator

public final class ProfileCoordinator {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  private weak var profileFinishDelegate: ProfileFinishFinishDelegate?
  public var flow: CoordinatorFlow = .profile
  private let isMockEnvironment: Bool

  public init(
    navigationController: UINavigationController,
    profileFinishDelegate: ProfileFinishFinishDelegate,
    isMockEnvironment: Bool = false
  ) {
    self.navigationController = navigationController
    self.profileFinishDelegate = profileFinishDelegate
    self.isMockEnvironment = isMockEnvironment
  }

  public func start() {
    guard
      let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String,
      let jsonProfilePath = Bundle(for: Self.self).path(forResource: "GetProfile", ofType: "json"),
      let jsonPostsPath = Bundle(for: Self.self).path(forResource: "GetPosts", ofType: "json"),
      let jsonProfileData = try? Data(contentsOf: .init(filePath: jsonProfilePath)),
      let jsonPostsData = try? Data(contentsOf: .init(filePath: jsonPostsPath))
    else {
      Log.make().error("Records Mock 데이터를 생성할 수 없습니다.")
      return
    }

    let mockData = [
      "\(baseURL)/api/v1/profiles": jsonProfileData,
      "\(baseURL)/api/v1/posts": jsonPostsData,
    ]

    let session: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockDataByURLString: mockData) : URLSession.shared

    let repository = ProfileRepository(session: session)
    let useCase = ProfileUseCase(repository: repository)
    let viewModel = ProfileViewModel(coordinating: self, useCase: useCase)
    let viewController = ProfileViewController(viewModel: viewModel)
    navigationController.setViewControllers([viewController], animated: false)
  }
}

// MARK: ProfileCoordinating

extension ProfileCoordinator: ProfileCoordinating {
  public func moveToLogin() {
    finish()
    profileFinishDelegate?.moveToLogin()
  }

  public func moveToProfileSettings() {
    let repository = ProfileSettingsRepository(persistency: .shared)
    let useCase = ProfileSettingsUseCase(repository: repository)
    let viewModel = ProfileSettingsViewModel(coordinating: self, useCase: useCase)
    let viewController = ProfileSettingsViewController(viewModel: viewModel)
    viewController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(viewController, animated: true)
  }

  public func pushToSettings() {
    let repository = KeychainRepository(keychain: Keychain.shared)
    let useCase = LogoutUseCase(keychainRepository: repository)
    let viewModel = SettingsViewModel(coordinating: self, useCase: useCase)
    let viewController = SettingsViewController(viewModel: viewModel)
    viewController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(viewController, animated: true)
  }

  public func presentWriteBoard() {
    let writeBoardCoordinator = WriteBoardCoordinator(
      navigationController: navigationController,
      delegate: self
    )
    childCoordinators.append(writeBoardCoordinator)
    writeBoardCoordinator.start()
  }
}

// MARK: CoordinatorFinishDelegate

extension ProfileCoordinator: CoordinatorFinishDelegate {
  public func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter { $0.flow != childCoordinator.flow }
    childCoordinator.childCoordinators.removeAll()
  }
}
