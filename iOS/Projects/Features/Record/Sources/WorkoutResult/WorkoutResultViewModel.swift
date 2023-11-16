//
//  WorkoutResultViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutResultPresentableListener

public protocol WorkoutResultPresentableListener: AnyObject {}

// MARK: - WorkoutResultViewModelRepresentable

public protocol WorkoutResultViewModelRepresentable {}

// MARK: - WorkoutResultViewModel

public final class WorkoutResultViewModel: WorkoutResultViewModelRepresentable, WorkoutResultPresentable {
  public weak var listener: WorkoutResultPresentableListener?

  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}
