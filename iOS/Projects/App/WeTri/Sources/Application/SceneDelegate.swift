//
//  SceneDelegate.swift
//  WeTri
//
//  Created by 홍승현 on 11/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import RecordFeature
import SignUpFeature
import UIKit

import DesignSystem

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var coordinating: AppCoordinating?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController()
    window?.rootViewController = navigationController
    let coordinator = SignUpFeatureCoordinator(navigationController: navigationController)
//    let coordinator = AppCoordinator(navigationController: navigationController)
//    coordinating = coordinator
    coordinator.start()
    window?.makeKeyAndVisible()
  }
}
