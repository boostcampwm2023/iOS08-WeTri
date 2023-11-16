//
//  WorkoutResultBuilder.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import WeTriArchitecture

// MARK: - WorkoutResultDependency

public protocol WorkoutResultDependency: Dependency {}

// MARK: - WorkoutResultComponent

public final class WorkoutResultComponent: Component<WorkoutResultDependency> {}

// MARK: - WorkoutResultBuildable

public protocol WorkoutResultBuildable {
  func build() -> WorkoutResultCoordinating
}

// MARK: - WorkoutResultBuilder

public final class WorkoutResultBuilder: Builder<WorkoutResultDependency>, WorkoutResultBuildable {
  override public init(dependency: WorkoutResultDependency) {
    super.init(dependency: dependency)
  }

  public func build() -> WorkoutResultCoordinating {
    let component = WorkoutResultComponent(dependency: dependency)

    let viewModel = WorkoutResultViewModel()
    let viewController = WorkoutResultViewController(viewModel: viewModel)

    let useCase = WorkoutResultUseCase(viewModel: viewModel)

    let coordinator = WorkoutResultCoordinator(useCase: useCase, viewController: viewController)

    return coordinator
  }
}
