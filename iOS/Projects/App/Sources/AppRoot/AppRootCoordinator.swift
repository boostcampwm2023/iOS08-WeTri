//
//  AppRootCoordinator.swift
//  WeTri
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import RecordFeature
import WeTriArchitecture

// MARK: - AppRootUseCaseRepresentable

protocol AppRootUseCaseRepresentable: UseCaseRepresentable {
  var coordinator: AppRootCoordinating? { get set }
  var listener: AppRootListener? { get set }
}

// MARK: - AppRootViewControllerRepresentable

protocol AppRootViewControllerRepresentable: ViewControllerRepresentable {
  func setupViewControllers(_ viewControllers: [ViewControllerRepresentable])
}

// MARK: - AppRootCoordinator

final class AppRootCoordinator: LaunchCoordinator<AppRootUseCaseRepresentable, AppRootViewControllerRepresentable>, AppRootCoordinating {
  private let recordHome: WorkoutSummaryBuildable
  private let resultHome: WorkoutResultBuildable

  init(
    useCase: AppRootUseCaseRepresentable,
    viewController: AppRootViewControllerRepresentable,
    recordHome: WorkoutSummaryBuildable,
    resultHome: WorkoutResultBuildable
  ) {
    self.recordHome = recordHome
    self.resultHome = resultHome
    super.init(useCase: useCase, viewController: viewController)
    useCase.coordinator = self
  }

  func attachTabs() {
    let recordCoordinator = recordHome.build()
    let resultCoordinator = resultHome.build()

    attachChild(recordCoordinator)
    attachChild(resultCoordinator)

    let viewControllers = [
      NavigationControllerRepresentable(rootViewController: resultCoordinator.viewControllerRepresentable),
      NavigationControllerRepresentable(rootViewController: recordCoordinator.viewControllerRepresentable),
    ]

    viewController.setupViewControllers(viewControllers)
  }
}
