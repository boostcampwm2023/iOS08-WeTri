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
  case shouldPresentHealthAuthorization
  case shouldPresentMapAuthorization
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

    let presentMapAuthorizationState = input.shouldPresentMapAuthorizationPublisher
      .tryMap { [weak self] _ -> OnboardingState in
        guard let self else {
          return .errorState(OnboardingViewModelError.didNotInitViewModel)
        }
        useCase.healthOnboardingImage()
        return .shouldPresentHealthAuthorization
      }.eraseToAnyPublisher()

    let initialState: OnboardingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}

// MARK: - OnboardingViewModelError

enum OnboardingViewModelError: LocalizedError {
  case didNotInitViewModel
}
