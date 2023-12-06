//
//  ProfileCoordinator.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Log
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
  public func pushToSettings() {
    // TODO: 설정창으로 이동
  }
}
