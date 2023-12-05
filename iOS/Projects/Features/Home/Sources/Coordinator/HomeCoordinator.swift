//
//  HomeFeatureCoordinator.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Coordinator
import UIKit

protocol HomeCoordinating: Coordinating {
  
}

final class HomeCoordinator: HomeCoordinating {
  var navigationController: UINavigationController
  
  var childCoordinators: [Coordinator.Coordinating] = []
  
  var finishDelegate: CoordinatorFinishDelegate?
  
  var flow: CoordinatorFlow
  init(navigationController: UINavigationController, delegate: CoordinatorFinishDelegate) {
    self.navigationController = navigationController
    self.finishDelegate = delegate
    self.flow = .login
  }
  
  func start() {
    let viewModel = HomeViewModel()
    let viewController = HomeViewController(viewModel: viewModel)
  }
  
  
}
