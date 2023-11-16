//
//  WorkoutSummaryBuilder.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import WeTriArchitecture

// MARK: - WorkoutSummaryDependency

public protocol WorkoutSummaryDependency: Dependency {}

// MARK: - WorkoutSummaryComponent

public final class WorkoutSummaryComponent: Component<WorkoutSummaryDependency>, WorkoutResultDependency {}

// MARK: - WorkoutSummaryBuildable

public protocol WorkoutSummaryBuildable {
  func build() -> WorkoutSummaryCoordinating
}

// MARK: - WorkoutSummaryBuilder

public final class WorkoutSummaryBuilder: Builder<WorkoutSummaryDependency>, WorkoutSummaryBuildable {
  override public init(dependency: WorkoutSummaryDependency) {
    super.init(dependency: dependency)
  }

  public func build() -> WorkoutSummaryCoordinating {
    let component = WorkoutSummaryComponent(dependency: dependency)

    let viewModel = WorkoutSummaryViewModel()
    let viewController = WorkoutSummaryViewController(viewModel: viewModel)
    let useCase = WorkoutSummaryUseCase(viewModel: viewModel)

    let workoutResult = WorkoutResultBuilder(dependency: component)

    let coordinator = WorkoutSummaryCoordinator(
      useCase: useCase,
      viewController: viewController,
      workoutResult: workoutResult
    )
    return coordinator
  }
}
