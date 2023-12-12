//
//  OnboardingCoordinator.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation
import UIKit

// MARK: - OnboardingFinishDelegate

public protocol OnboardingFinishDelegate {
  func finishOnboarding()
}

// MARK: - OnboardingCoordinating

public protocol OnboardingCoordinating: Coordinating {
  func startOnboardingFlow()
  func finishOnBoardingFlow()
}

// MARK: - OnboardingCoordinator

public final class OnboardingCoordinator: OnboardingCoordinating {
  public var navigationController: UINavigationController

  public var childCoordinators: [Coordinating] = []

  public var finishDelegate: CoordinatorFinishDelegate?

  public let onboardingFinishDelegate: OnboardingFinishDelegate?

  public let flow: CoordinatorFlow = .onboarding

  public func start() {
    startOnboardingFlow()
  }

  public init(
    navigationController: UINavigationController,
    finishDelegate: CoordinatorFinishDelegate? = nil,
    onboardingFinishDelegate: OnboardingFinishDelegate
  ) {
    self.navigationController = navigationController
    self.finishDelegate = finishDelegate
    self.onboardingFinishDelegate = onboardingFinishDelegate
  }

  public func startOnboardingFlow() {
    let repository = OnboardingPropertyLoadRepository()
    let useCase = OnboardingPropertyLoadUseCase(repository: repository)
    let viewModel = OnboardingViewModel(useCase: useCase, coordinator: self)
    let viewController = OnboardingViewController(viewModel: viewModel)

    navigationController.setViewControllers([viewController], animated: true)
  }

  public func finishOnBoardingFlow() {
    childCoordinators.removeAll()

    onboardingFinishDelegate?.finishOnboarding()
  }
}
