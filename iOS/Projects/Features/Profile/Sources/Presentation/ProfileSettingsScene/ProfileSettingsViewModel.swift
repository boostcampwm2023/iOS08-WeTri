//
//  ProfileSettingsViewModel.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - ProfileSettingsViewModelInput

public struct ProfileSettingsViewModelInput {}

public typealias ProfileSettingsViewModelOutput = AnyPublisher<ProfileSettingsState, Never>

// MARK: - ProfileSettingsState

public enum ProfileSettingsState {
  case idle
}

// MARK: - ProfileSettingsViewModelRepresentable

protocol ProfileSettingsViewModelRepresentable {
  func transform(input: ProfileSettingsViewModelInput) -> ProfileSettingsViewModelOutput
}

// MARK: - ProfileSettingsViewModel

final class ProfileSettingsViewModel {
  // MARK: - Properties

  private weak var coordinating: ProfileCoordinating?

  private var subscriptions: Set<AnyCancellable> = []

  init(coordinating: ProfileCoordinating? = nil) {
    self.coordinating = coordinating
  }
}

// MARK: ProfileSettingsViewModelRepresentable

extension ProfileSettingsViewModel: ProfileSettingsViewModelRepresentable {
  public func transform(input _: ProfileSettingsViewModelInput) -> ProfileSettingsViewModelOutput {
    subscriptions.removeAll()

    let initialState: ProfileSettingsViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
