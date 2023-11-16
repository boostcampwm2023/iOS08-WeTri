//
//  SceneDelegate.swift
//  WeTri
//
//  Created by 홍승현 on 11/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import RecordFeature
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)
    let nvc = UINavigationController(rootViewController: ExerciseEnvironmentSetupViewController())
    window?.rootViewController = nvc
    window?.makeKeyAndVisible()
  }
}
