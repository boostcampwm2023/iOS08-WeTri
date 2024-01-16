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

public struct ContainerViewModelInput {
  let showAlertPublisher: AnyPublisher<Void, Never>
  let dismissWriteBoardPublisher: AnyPublisher<Void, Never>
}

public typealias ContainerViewModelOutput = AnyPublisher<ContainerState, Never>

// MARK: - ContainerState

public enum ContainerState {
  case idle
  case showAlert
}

// MARK: - ContainerViewModelRepresentable

protocol ContainerViewModelRepresentable {
  func transform(input: ContainerViewModelInput) -> ContainerViewModelOutput
}

// MARK: - ContainerViewModel

final class ContainerViewModel {
  // MARK: - Properties

  private weak var coordinator: WriteBoardFeatureCoordinating?

  private var subscriptions: Set<AnyCancellable> = []

  init(coordinator: WriteBoardFeatureCoordinating) {
    self.coordinator = coordinator
  }
}

// MARK: ContainerViewModelRepresentable

extension ContainerViewModel: ContainerViewModelRepresentable {
  public func transform(input: ContainerViewModelInput) -> ContainerViewModelOutput {
    subscriptions.removeAll()

    let showAlert: ContainerViewModelOutput = input
      .showAlertPublisher
      .map { _ in ContainerState.showAlert }
      .eraseToAnyPublisher()

    input.dismissWriteBoardPublisher
      .sink { [weak self] _ in
        self?.coordinator?.cancelWriteBoard()
      }
      .store(in: &subscriptions)

    let initialState: ContainerViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: showAlert).eraseToAnyPublisher()
  }
}
