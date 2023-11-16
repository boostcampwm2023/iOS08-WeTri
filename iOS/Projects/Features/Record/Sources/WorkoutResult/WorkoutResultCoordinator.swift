//
//  WorkoutResultCoordinator.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import WeTriArchitecture

// MARK: - WorkoutResultUseCaseRepresentable

public protocol WorkoutResultUseCaseRepresentable: UseCaseRepresentable {
  var coordinator: WorkoutResultCoordinating? { get set }
  var listener: WorkoutResultListener? { get set }
}

// MARK: - WorkoutResultViewControllerRepresentable

public protocol WorkoutResultViewControllerRepresentable: ViewControllerRepresentable {}

// MARK: - WorkoutResultCoordinator

public final class WorkoutResultCoordinator: Coordinator<WorkoutResultUseCaseRepresentable, WorkoutResultViewControllerRepresentable>, WorkoutResultCoordinating {
  override public init(
    useCase: WorkoutResultUseCaseRepresentable,
    viewController: WorkoutResultViewControllerRepresentable
  ) {

    super.init(useCase: useCase, viewController: viewController)

    useCase.coordinator = self
  }

  deinit {
    print(#function)
  }
}
