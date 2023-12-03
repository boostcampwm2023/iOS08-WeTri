//
//  SplashCoordinator.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

final class SplashCoordinator: SplashCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .splash

  init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
  }

  func start() {
    let viewController = SplashViewController(viewModel: SplashViewModel())
    navigationController.pushViewController(viewController, animated: false)
  }
}
