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
  func pushWriteBoardScene(record: Record)
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
    delegate: CoordinatorFinishDelegate?
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

    vc.modalPresentationStyle = .automatic
    navigationController.present(vc, animated: true)
    pushWorkoutHistorySelectScene()
  }

  private func pushWorkoutHistorySelectScene() {
    let viewModel = WorkoutHistorySelectViewModel()
    viewModel.writeBoardCoordinator = self
    let viewController = WorkoutHistorySelectViewController(viewModel: viewModel)

    containerViewController?.pushViewController(viewController, animated: false)
  }

  public func pushWriteBoardScene(record: Record) {
    let viewModel = WriteBoardViewModel(record: record)
    let viewController = WriteBoardViewController(viewModel: viewModel)

    containerViewController?.pushViewController(viewController, animated: true)
  }

  public func didFinishWriteBoard() {}

  public func cancelWriteBoard() {
    childCoordinators.removeAll()
    navigationController.dismiss(animated: true)
    finishDelegate?.flowDidFinished(childCoordinator: self)
  }
}
