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
  case shouldPresentMapAuthorization(OnboardingScenePropertyDTO)
  case shouldPresentHealthAuthorization(OnboardingScenePropertyDTO)
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

  private var useCase: OnboardingImageLoadUseCaseRepresentable
  public init(useCase: OnboardingImageLoadUseCaseRepresentable) {
    self.useCase = useCase
  }

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: OnboardingViewModelRepresentable

extension OnboardingViewModel: OnboardingViewModelRepresentable {
  public func transform(input: OnboardingViewModelInput) -> OnboardingViewModelOutput {
    subscriptions.removeAll()

    let presentMapAuth: OnboardingViewModelOutput = input.shouldPresentMapAuthorizationPublisher
      .tryMap { [weak self] _ -> OnboardingState in
        guard let self else {
          return .errorState(OnboardingViewModelError.didNotInitViewModel)
        }
        guard let dto = useCase.mapOnboardingImage() else {
          return .errorState(OnboardingViewModelError.nilValue)
        }
        return .shouldPresentMapAuthorization(dto)
      }
      .catch { error in return Just(OnboardingState.errorState(error)) }
      .eraseToAnyPublisher()

    let presentHealthAuth: OnboardingViewModelOutput = input.shouldPresentHealthAuthorizationPublisher
      .tryMap { [weak self] _ -> OnboardingState in
        guard let self else {
          return .errorState(OnboardingViewModelError.didNotInitViewModel)
        }
        guard let dto = useCase.healthOnboardingImage() else {
          return .errorState(OnboardingViewModelError.nilValue)
        }
        return .shouldPresentHealthAuthorization(dto)
      }
      .catch { error in return Just(OnboardingState.errorState(error)) }
      .eraseToAnyPublisher()

    let initialState: OnboardingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: presentHealthAuth, presentMapAuth).eraseToAnyPublisher()
  }
}

// MARK: - OnboardingViewModelError

enum OnboardingViewModelError: LocalizedError {
  case didNotInitViewModel
  case nilValue
}
