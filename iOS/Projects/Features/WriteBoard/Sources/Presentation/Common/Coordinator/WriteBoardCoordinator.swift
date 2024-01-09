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
  func pushWorkoutHistorySelectScene()
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

  init(
    navigationController: UINavigationController,
    delegate: CoordinatorFinishDelegate
  ) {
    self.navigationController = navigationController
    finishDelegate = delegate
  }

  public func start() {
    pushWorkoutHistorySelectScene()
  }

  public func pushWorkoutHistorySelectScene() {}

  public func pushWriteBoardScene() {}

  public func didFinishWriteBoard() {}

  public func cancelWriteBoard() {}
}
