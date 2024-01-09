// 
//  ContainerViewModel.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - ContainerViewModelInput

public struct ContainerViewModelInput {}

public typealias ContainerViewModelOutput = AnyPublisher<ContainerState, Never>

// MARK: - ContainerState

public enum ContainerState {
  case idle
}

// MARK: - ContainerViewModelRepresentable

protocol ContainerViewModelRepresentable {
  func transform(input: ContainerViewModelInput) -> ContainerViewModelOutput
}

final class ContainerViewModel {

  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

extension ContainerViewModel: ContainerViewModelRepresentable {
  public func transform(input: ContainerViewModelInput) -> ContainerViewModelOutput {
    subscriptions.removeAll()


    let initialState: ContainerViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
