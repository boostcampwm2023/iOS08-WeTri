//
//  SettingsViewModel.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log

// MARK: - SettingsViewModelInput

public struct SettingsViewModelInput {
  let profileSettingsPublisher: AnyPublisher<Void, Never>
  let logoutPublisher: AnyPublisher<Void, Never>
}

public typealias SettingsViewModelOutput = AnyPublisher<SettingsState, Never>

// MARK: - SettingsState

public enum SettingsState {
  case idle
}

// MARK: - SettingsViewModelRepresentable

protocol SettingsViewModelRepresentable {
  func transform(input: SettingsViewModelInput) -> SettingsViewModelOutput
}

// MARK: - SettingsViewModel

final class SettingsViewModel {
  // MARK: - Properties

  private weak var coordinating: ProfileCoordinating?
  private let useCase: LogoutUseCaseRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  init(coordinating: ProfileCoordinating?, useCase: LogoutUseCaseRepresentable) {
    self.coordinating = coordinating
    self.useCase = useCase
  }

  deinit {
    Log.make().debug("\(Self.self) deinitialized")
  }
}

// MARK: SettingsViewModelRepresentable

extension SettingsViewModel: SettingsViewModelRepresentable {
  public func transform(input: SettingsViewModelInput) -> SettingsViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    input.profileSettingsPublisher
      .sink { [coordinating] in
        coordinating?.moveToProfileSettings()
      }
      .store(in: &subscriptions)

    let initialState: SettingsViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
