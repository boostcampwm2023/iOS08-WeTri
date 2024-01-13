//
//  TabBarCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import DesignSystem
import HomeFeature
import ProfileFeature
import RecordFeature
import UIKit

// MARK: - TabBarFinishDelegate

protocol TabBarFinishDelegate: AnyObject {
  func moveToLogin()
}

// MARK: - TabBarCoordinator

final class TabBarCoordinator: TabBarCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  private weak var tabBarFinishDelegate: TabBarFinishDelegate?
  var flow: CoordinatorFlow = .tabBar
  var tabBarController: UITabBarController

  init(
    navigationController: UINavigationController,
    tabBarFinishDelegate: TabBarFinishDelegate,
    tabBarController: UITabBarController = UITabBarController()
  ) {
    self.navigationController = navigationController
    self.tabBarFinishDelegate = tabBarFinishDelegate
    self.tabBarController = tabBarController
  }

  func start() {
    let tabBarViewControllers = TabBarPage.allCases.map {
      return makePageNavigationController(page: $0)
    }
    let tabBarController = makeTabBarController(tabBarViewControllers: tabBarViewControllers)
    UITabBar.appearance().tintColor = DesignSystemColor.main03
    navigationController.setViewControllers([tabBarController], animated: true)
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
      let coordinator = HomeCoordinator(
        navigationController: pageNavigationViewController,
        delegate: self
      )
      childCoordinators.append(coordinator)
      coordinator.start()
    case .record:
      let recordCoordinator = RecordFeatureCoordinator(
        navigationController: pageNavigationViewController,
        isMockEnvironment: false
      )
      childCoordinators.append(recordCoordinator)
      recordCoordinator.finishDelegate = self
      recordCoordinator.start()

    case .profile:
      let profileCoordinator = ProfileCoordinator(
        navigationController: pageNavigationViewController,
        profileFinishDelegate: self,
        isMockEnvironment: false
      )
      childCoordinators.append(profileCoordinator)
      profileCoordinator.finishDelegate = self
      profileCoordinator.start()
    default:
      break
    }
  }

  private func makeTabBarController(
    tabBarViewControllers: [UIViewController]
  ) -> UITabBarController {
    tabBarController.setViewControllers(tabBarViewControllers, animated: true)
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

// MARK: ProfileFinishFinishDelegate

extension TabBarCoordinator: ProfileFinishFinishDelegate {
  func moveToLogin() {
    finish()
    tabBarFinishDelegate?.moveToLogin()
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
      return UIImage(systemName: "figure.run")
    case .profile:
      return UIImage(systemName: "person")
    }
  }

  var selectedImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "house.fill")
    case .record:
      return UIImage(systemName: "figure.run")
    case .profile:
      return UIImage(systemName: "person.fill")
    }
  }
}
