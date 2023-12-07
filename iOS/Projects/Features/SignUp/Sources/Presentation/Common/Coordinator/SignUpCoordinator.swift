//
//  SignUpCoordinator.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

final class SignUpCoordinator: SignUpCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .signup

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    //
  }

  func pushSingUpContainerViewController() {
    //
  }
}
