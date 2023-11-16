//
//  WorkoutSummaryUsecase.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import WeTriArchitecture

// MARK: - WorkoutSummaryCoordinating

public protocol WorkoutSummaryCoordinating: Coordinating {
  func pushedToResultScreen()
}

// MARK: - WorkoutSummaryPresentable

public protocol WorkoutSummaryPresentable: AnyObject {
  var listener: WorkoutSummaryPresentableListener? { get set }
}

// MARK: - WorkoutSummaryListener

public protocol WorkoutSummaryListener: AnyObject {}

// MARK: - WorkoutSummaryUseCase

public final class WorkoutSummaryUseCase: UseCase<WorkoutSummaryPresentable>, WorkoutSummaryUseCaseRepresentable, WorkoutSummaryPresentableListener {
  public weak var coordinator: WorkoutSummaryCoordinating?
  public weak var listener: WorkoutSummaryListener?

  override public init(viewModel: WorkoutSummaryPresentable) {
    super.init(viewModel: viewModel)
    viewModel.listener = self
  }

  public func moveToResult() {
    coordinator?.pushedToResultScreen()
  }
}
