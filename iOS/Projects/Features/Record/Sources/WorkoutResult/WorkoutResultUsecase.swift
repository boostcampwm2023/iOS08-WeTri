//
//  WorkoutResultUsecase.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import WeTriArchitecture

// MARK: - WorkoutResultCoordinating

public protocol WorkoutResultCoordinating: Coordinating {}

// MARK: - WorkoutResultPresentable

public protocol WorkoutResultPresentable: AnyObject {
  var listener: WorkoutResultPresentableListener? { get set }
}

// MARK: - WorkoutResultListener

public protocol WorkoutResultListener: AnyObject {}

// MARK: - WorkoutResultUseCase

public final class WorkoutResultUseCase: UseCase<WorkoutResultPresentable>, WorkoutResultUseCaseRepresentable, WorkoutResultPresentableListener {
  public weak var coordinator: WorkoutResultCoordinating?
  public weak var listener: WorkoutResultListener?

  override public init(viewModel: WorkoutResultPresentable) {
    super.init(viewModel: viewModel)
    viewModel.listener = self
  }

  override public func didBecomeActive() {
    super.didBecomeActive()
  }

  override public func willResignActive() {
    super.willResignActive()
  }
}
