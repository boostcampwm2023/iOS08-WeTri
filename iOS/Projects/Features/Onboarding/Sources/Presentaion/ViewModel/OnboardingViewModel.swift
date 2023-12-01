//
//  OnboardingViewModel.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - OnboardingViewModelInput

public struct OnboardingViewModelInput {
  let shouldPresentMapAuthorizationPublisher: AnyPublisher<Void, Never>
  let shouldPresentHealthAuthorizationPublisher: AnyPublisher<Void, Never>
}

public typealias OnboardingViewModelOutput = AnyPublisher<OnboardingState, Never>

// MARK: - OnboardingState

public enum OnboardingState {
  case idle
  case shouldPresentMapAuthorization(OnboardingScenePropertyResponse)
  case shouldPresentHealthAuthorization(OnboardingScenePropertyResponse)
  case finish
  case errorState(Error)
}

// MARK: - OnboardingViewModelRepresentable

public protocol OnboardingViewModelRepresentable {
  func transform(input: OnboardingViewModelInput) -> OnboardingViewModelOutput
}

// MARK: - OnboardingViewModel

public final class OnboardingViewModel {
  // MARK: - Properties

  private var useCase: OnboardingPropertyLoadUseCaseRepresentable
  public init(useCase: OnboardingPropertyLoadUseCaseRepresentable) {
    self.useCase = useCase
  }

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: OnboardingViewModelRepresentable

extension OnboardingViewModel: OnboardingViewModelRepresentable {
  public func transform(input: OnboardingViewModelInput) -> OnboardingViewModelOutput {
    subscriptions.removeAll()

    let presentMapAuth: OnboardingViewModelOutput = input.shouldPresentMapAuthorizationPublisher
      .map { [useCase] _ in
        guard let response = useCase.loadOnboardingMapAuthProperty() else {
          return .errorState(OnboardingViewModelError.nilValue)
        }
        return .shouldPresentMapAuthorization(response)
      }
      .eraseToAnyPublisher()

    let presentHealthAuth: OnboardingViewModelOutput = input.shouldPresentHealthAuthorizationPublisher
      .map { [useCase] _ -> OnboardingState in
        guard let response = useCase.loadOnboardingHealthAuthProperty() else {
          return .errorState(OnboardingViewModelError.nilValue)
        }
        return .shouldPresentHealthAuthorization(response)
      }
      .eraseToAnyPublisher()

    let initialState: OnboardingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: presentHealthAuth, presentMapAuth).eraseToAnyPublisher()
  }
}

// MARK: - OnboardingViewModelError

enum OnboardingViewModelError: LocalizedError {
  case nilValue
}
