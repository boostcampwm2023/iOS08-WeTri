//
//  WorkoutSummaryCoordinator.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import WeTriArchitecture

// MARK: - WorkoutSummaryUseCaseRepresentable

public protocol WorkoutSummaryUseCaseRepresentable: UseCaseRepresentable {
  var coordinator: WorkoutSummaryCoordinating? { get set }
  var listener: WorkoutSummaryListener? { get set }
}

// MARK: - WorkoutSummaryViewControllerRepresentable

public protocol WorkoutSummaryViewControllerRepresentable: ViewControllerRepresentable {
  func pushToScreen(_ viewController: ViewControllerRepresentable)
}

// MARK: - WorkoutSummaryCoordinator

public final class WorkoutSummaryCoordinator: Coordinator<WorkoutSummaryUseCaseRepresentable, WorkoutSummaryViewControllerRepresentable>, WorkoutSummaryCoordinating {
  private let workoutResult: WorkoutResultBuildable

  public init(
    useCase: WorkoutSummaryUseCaseRepresentable,
    viewController: WorkoutSummaryViewControllerRepresentable,
    workoutResult: WorkoutResultBuildable
  ) {
    self.workoutResult = workoutResult
    super.init(useCase: useCase, viewController: viewController)
    useCase.coordinator = self
  }

  public func pushedToResultScreen() {
    let workoutResultCoordinating = workoutResult.build()

    attachChild(workoutResultCoordinating)
    print(#function)
    viewController.pushToScreen(workoutResultCoordinating.viewControllerRepresentable)
  }
}
