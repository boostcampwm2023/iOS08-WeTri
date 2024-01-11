//
//  WriteBoardViewModel.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WriteBoardViewModelInput

public struct WriteBoardViewModelInput {}

public typealias WriteBoardViewModelOutput = AnyPublisher<WriteBoardState, Never>

// MARK: - WriteBoardState

public enum WriteBoardState {
  case idle
}

// MARK: - WriteBoardViewModelRepresentable

protocol WriteBoardViewModelRepresentable {
  func transform(input: WriteBoardViewModelInput) -> WriteBoardViewModelOutput
}

// MARK: - WriteBoardViewModel

final class WriteBoardViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: WriteBoardViewModelRepresentable

extension WriteBoardViewModel: WriteBoardViewModelRepresentable {
  public func transform(input _: WriteBoardViewModelInput) -> WriteBoardViewModelOutput {
    subscriptions.removeAll()

    let initialState: WriteBoardViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
