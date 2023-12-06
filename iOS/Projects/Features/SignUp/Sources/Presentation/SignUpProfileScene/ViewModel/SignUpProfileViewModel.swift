//
//  SignUpProfileViewModel.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log

// MARK: - SignUpProfileViewModelInput

public struct SignUpProfileViewModelInput {
  let maleButtonTap: AnyPublisher<Void, Never>
  let femaleButtonTap: AnyPublisher<Void, Never>
  let birthSelect: AnyPublisher<Date, Never>
}

public typealias SignUpProfileViewModelOutput = AnyPublisher<SignUpGenderBirthState, Never>

// MARK: - SignUpProfileState

public enum SignUpProfileState {
  case idle
}

// MARK: - SignUpProfileViewModel

public final class SignUpProfileViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateFormatUseCase: DateFormatUseCaseRepresentable

  public init(dateFormatUseCase: DateFormatUseCaseRepresentable) {
    self.dateFormatUseCase = dateFormatUseCase
  }
}

// MARK: SignUpProfileViewModelRepresentable

extension SignUpProfileViewModel: SignUpProfileViewModelRepresentable {
  public func transform(input _: SignUpGenderBirthViewModelInput) -> SignUpGenderBirthViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let initialState: SignUpGenderBirthViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    return initialState
      .eraseToAnyPublisher()
  }
}

// MARK: - SignUpProfileViewModelRepresentable

public protocol SignUpProfileViewModelRepresentable {
  func transform(input: SignUpGenderBirthViewModelInput) -> SignUpGenderBirthViewModelOutput
}

// MARK: - SignUpProfileViewModelError

enum SignUpProfileViewModelError: Error {
  case invalidBinding
}
