// 
//  SelectWorkoutViewModel.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - SelectWorkoutViewModelInput

public struct SelectWorkoutViewModelInput {}

public typealias SelectWorkoutViewModelOutput = AnyPublisher<SelectWorkoutState, Never>

// MARK: - SelectWorkoutState

public enum SelectWorkoutState {
  case idle
}

// MARK: - SelectWorkoutViewModelRepresentable

protocol SelectWorkoutViewModelRepresentable {
  func transform(input: SelectWorkoutViewModelInput) -> SelectWorkoutViewModelOutput
}

final class SelectWorkoutViewModel {

  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

extension SelectWorkoutViewModel: SelectWorkoutViewModelRepresentable {
  public func transform(input: SelectWorkoutViewModelInput) -> SelectWorkoutViewModelOutput {
    subscriptions.removeAll()


    let initialState: SelectWorkoutViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
