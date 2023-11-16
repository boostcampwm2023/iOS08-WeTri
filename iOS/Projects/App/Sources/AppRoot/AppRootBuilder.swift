//
//  AppRootBuilder.swift
//  WeTri
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import RecordFeature
import WeTriArchitecture

// MARK: - AppRootDependency

protocol AppRootDependency: Dependency {}

// MARK: - AppRootComponent

final class AppRootComponent: Component<AppRootDependency>, WorkoutSummaryDependency, WorkoutResultDependency {}

// MARK: - AppRootBuildable

protocol AppRootBuildable: Buildable {
  func build() -> LaunchCoordinating
}

// MARK: - AppRootBuilder

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
  override init(dependency: AppRootDependency) {
    super.init(dependency: dependency)
  }

  func build() -> LaunchCoordinating {
    let component = AppRootComponent(dependency: dependency)

    let viewController = AppRootViewController()

    let useCase = AppRootUseCase(presenter: viewController)

    let recordHome = WorkoutSummaryBuilder(dependency: component)
    let resultHome = WorkoutResultBuilder(dependency: component)

    let coordinator = AppRootCoordinator(
      useCase: useCase,
      viewController: viewController,
      recordHome: recordHome,
      resultHome: resultHome
    )
    return coordinator
  }
}
