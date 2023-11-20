//
//  RecordFeatureCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import UIKit

public final class RecordFeatureCoordinator: RecordFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .workoutSetting
  public var recordContainerViewController: RecordContainerViewController

  public init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
    recordContainerViewController = RecordContainerViewController()
  }

  public func start() {
    navigationController.pushViewController(recordContainerViewController, animated: false)
  }

  func showSettingFlow() {
    //
  }

  func showWorkoutFlow() {
    //
  }
}
