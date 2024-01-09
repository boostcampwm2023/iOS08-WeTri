//
//  WriteBoardCoordinator.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation
import Log
import UIKit

// MARK: - WriteBoardFeatureFinishDelegate

public protocol WriteBoardFeatureFinishDelegate: AnyObject {
  func writeBoardFeatureDiDFinish()
}

// MARK: - WriteBoardFeatureCoordinating

public protocol WriteBoardFeatureCoordinating: Coordinating {
  func pushWriteBoardScene()
  func didFinishWriteBoard()
  func cancelWriteBoard()
}

// MARK: - WriteBoardCoordinator

public final class WriteBoardCoordinator: WriteBoardFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .writeBoard

  private var containerViewController: UINavigationController?

  public init(
    navigationController: UINavigationController,
    delegate: CoordinatorFinishDelegate
  ) {
    self.navigationController = navigationController
    finishDelegate = delegate
  }

  public func start() {
    pushContainerViewController()
  }

  private func pushContainerViewController() {
    let viewModel = ContainerViewModel(coordinator: self)
    let vc = ContainerViewController(viewModel: viewModel)
    containerViewController = vc

    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: true)
    pushWorkoutHistorySelectScene()
  }

  private func pushWorkoutHistorySelectScene() {
    let viewModel = WorkoutHistorySelectViewModel()
    let viewController = WorkoutHistorySelectViewController(viewModel: viewModel)

    containerViewController?.setViewControllers([viewController], animated: true)
  }

  public func pushWriteBoardScene() {}

  public func didFinishWriteBoard() {}

  public func cancelWriteBoard() {}
}
