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

public struct ProfileSettingsViewModelInput {
  let viewDidLoad: AnyPublisher<Void, Never>
}

public typealias ProfileSettingsViewModelOutput = AnyPublisher<ProfileSettingsState, Never>

// MARK: - ProfileSettingsState

public enum ProfileSettingsState {
  case idle
  case alert(Error)
  case profile(Profile)
}

// MARK: - ProfileSettingsViewModelRepresentable

protocol ProfileSettingsViewModelRepresentable {
  func transform(input: ProfileSettingsViewModelInput) -> ProfileSettingsViewModelOutput
}

// MARK: - ProfileSettingsViewModel

final class ProfileSettingsViewModel {
  // MARK: - Properties

  private weak var coordinating: ProfileCoordinating?
  private let useCase: ProfileSettingsUseCase

  private var subscriptions: Set<AnyCancellable> = []

  init(coordinating: ProfileCoordinating?, useCase: ProfileSettingsUseCase) {
    self.coordinating = coordinating
    self.useCase = useCase
  }
}

// MARK: ProfileSettingsViewModelRepresentable

extension ProfileSettingsViewModel: ProfileSettingsViewModelRepresentable {
  public func transform(input: ProfileSettingsViewModelInput) -> ProfileSettingsViewModelOutput {
    subscriptions.removeAll()

    let profilePublisher = input.viewDidLoad
      .tryMap(useCase.userInformation)
      .map(ProfileSettingsState.profile)
      .catch { Just(.alert($0)) }

    return Just(.idle).merge(with: profilePublisher).eraseToAnyPublisher()
  }
}
