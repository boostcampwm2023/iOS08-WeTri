//
//  TabBarCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import ProfileFeature
import RecordFeature
import UIKit

// MARK: - TabBarCoordinator

final class TabBarCoordinator: TabBarCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .tabBar
  var tabBarController: UITabBarController

  init(
    navigationController: UINavigationController,
    tabBarController: UITabBarController = UITabBarController()
  ) {
    self.navigationController = navigationController
    self.tabBarController = tabBarController
  }

  func start() {
    let tabBarViewControllers = TabBarPage.allCases.map {
      return makePageNavigationController(page: $0)
    }
    let tabBarController = makeTabBarController(tabBarViewControllers: tabBarViewControllers)
    navigationController.pushViewController(tabBarController, animated: false)
  }

  private func makePageNavigationController(page: TabBarPage) -> UINavigationController {
    let navigationController = UINavigationController()
    let tabBarItem = UITabBarItem(title: page.title, image: page.image, selectedImage: page.selectedImage)
    navigationController.tabBarItem = tabBarItem
    startTabBarCoordinator(page: page, pageNavigationViewController: navigationController)
    return navigationController
  }

  private func startTabBarCoordinator(page: TabBarPage, pageNavigationViewController: UINavigationController) {
    switch page {
    case .home:
      let homeCoordinator = ACoordinator(navigationController: pageNavigationViewController)
      childCoordinators.append(homeCoordinator)
      homeCoordinator.finishDelegate = self
      homeCoordinator.start()

    case .record:
      let recordCoordinator = RecordFeatureCoordinator(
        navigationController: pageNavigationViewController,
        isMockEnvironment: true
      )
      childCoordinators.append(recordCoordinator)
      recordCoordinator.finishDelegate = self
      recordCoordinator.start()

    case .profile:
      let profileCoordinator = ProfileCoordinator(navigationController: pageNavigationViewController)
      childCoordinators.append(profileCoordinator)
      profileCoordinator.finishDelegate = self
      profileCoordinator.start()
    }
  }

  private func makeTabBarController(
    tabBarViewControllers: [UIViewController]
  ) -> UITabBarController {
    tabBarController.setViewControllers(tabBarViewControllers, animated: false)
    return tabBarController
  }
}

// MARK: CoordinatorFinishDelegate

extension TabBarCoordinator: CoordinatorFinishDelegate {
  func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter {
      return $0.flow != childCoordinator.flow
    }
  }
}

// MARK: - TabBarPage

private enum TabBarPage: CaseIterable {
  case home
  case record
  case profile
}

private extension TabBarPage {
  var title: String {
    switch self {
    case .home:
      return "홈"
    case .record:
      return "기록"
    case .profile:
      return "프로필"
    }
  }

  var image: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "house")
    case .record:
      return UIImage(systemName: "star")
    case .profile:
      return UIImage(systemName: "person")
    }
  }

  var selectedImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "house.fill")
    case .record:
      return UIImage(systemName: "star.fill")
    case .profile:
      return UIImage(systemName: "person.fill")
    }
  }
}
