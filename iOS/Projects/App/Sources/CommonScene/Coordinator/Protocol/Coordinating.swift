//
//  Coordinating.swift
//  WeTri
//
//  Created by 안종표 on 2023/11/15.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - Coordinating

protocol Coordinating: AnyObject {
  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinating] { get set }
  var finishDelegate: CoordinatorFinishDelegate { get set }
  var flow: CoordinatorFlow { get }

  func start()
  func finish(childCoordinator: Coordinating)
}

extension Coordinating {
  func finish(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter { $0.flow != childCoordinator.flow }
  }
}

// MARK: - CoordinatorFlow

enum CoordinatorFlow {
  case login
  case tabBar
}
