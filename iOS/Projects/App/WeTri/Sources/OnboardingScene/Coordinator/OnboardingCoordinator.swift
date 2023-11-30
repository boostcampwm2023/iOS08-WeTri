//
//  OnboardingCoordinator.swift
//  WeTri
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation
import OnboardingFeature
import UIKit

// MARK: - OnboardingCoordinating

protocol OnboardingCoordinating: Coordinating {
  func didSuccessAuthorization()
  func didFailAuthorization()
}

// MARK: - OnboardingCoordinator

final class OnboardingCoordinator: OnboardingCoordinating {
  func didSuccessAuthorization() {}

  func didFailAuthorization() {}

  var navigationController: UINavigationController

  var childCoordinators: [Coordinating] = []

  var finishDelegate: CoordinatorFinishDelegate?

  var flow: CoordinatorFlow = .onboarding

  func start() {
    let repository = OnboardingPropertyLoadRepository()
    let useCase = OnboardingPropertyLoadUseCase(repository: repository)
    let viewModel = OnboardingViewModel(useCase: useCase)
    let viewController = OnboardingViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: false)
  }

  init(
    navigationController: UINavigationController,
    finishDelegate: CoordinatorFinishDelegate? = nil
  ) {
    self.navigationController = navigationController
    self.finishDelegate = finishDelegate
  }
}
