//
//  SceneDelegate.swift
//  WeTri
//
//  Created by 홍승현 on 11/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit
import WeTriArchitecture

// MARK: - AppComponent

final class AppComponent: Component<EmptyDependency>, AppRootDependency {}

// MARK: - SceneDelegate

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var launchCoordinator: LaunchCoordinating?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)
    self.window = window
    window.rootViewController = UIViewController()
    window.makeKeyAndVisible()

    let launchCoordinator = AppRootBuilder(dependency: AppComponent(dependency: EmptyComponent())).build()
    self.launchCoordinator = launchCoordinator

    launchCoordinator.launch(from: window)
  }
}

// MARK: - NavigationControllerRepresentable

final class NavigationControllerRepresentable: ViewControllerRepresentable {
  private let navigationController: UINavigationController
  var viewController: UIViewController { navigationController }

  public init(rootViewController: ViewControllerRepresentable) {
    navigationController = UINavigationController(rootViewController: rootViewController.viewController)
  }
}
