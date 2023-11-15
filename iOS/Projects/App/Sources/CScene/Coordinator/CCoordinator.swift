//
//  CCoordinator.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

final class CCoordinator: CCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .tabBar

  init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
  }

  func start() {
    let viewController = CViewController()
    navigationController.pushViewController(viewController, animated: false)
  }
}
