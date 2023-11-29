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

public struct OnboardingViewModelInput {}

public typealias OnboardingViewModelOutput = AnyPublisher<OnboardingState, Never>

// MARK: - OnboardingState

public enum OnboardingState {
  case idle
}

// MARK: - OnboardingViewModelRepresentable

protocol OnboardingViewModelRepresentable {
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
  public func transform(input _: OnboardingViewModelInput) -> OnboardingViewModelOutput {
    subscriptions.removeAll()

    let initialState: OnboardingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
