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

final class OnboardingViewModel {

  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

extension OnboardingViewModel: OnboardingViewModelRepresentable {
  public func transform(input: OnboardingViewModelInput) -> OnboardingViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()


    let initialState: OnboardingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
