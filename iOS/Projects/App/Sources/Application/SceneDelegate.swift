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
    let navigationController = UINavigationController()
    window = UIWindow(windowScene: windowScene)
<<<<<<< 4d503049592a790312cea053ab0745c044bf3168:iOS/Projects/App/Sources/SceneDelegate.swift
    let nvc = UINavigationController(rootViewController: ExerciseSelectController())
    window?.rootViewController = nvc
=======
    window?.rootViewController = navigationController
    let coordinator = AppCoordinator(navigationController: navigationController)
    coordinator.start()
>>>>>>> [GWL-40] Root Coordinator 세팅 (#48):iOS/Projects/App/Sources/Application/SceneDelegate.swift
    window?.makeKeyAndVisible()
  }
}
