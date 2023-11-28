//
//  LoginViewModel.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - LoginViewModelInput

struct LoginViewModelInput {
  let appleLoginButtonDidTap: AnyPublisher<AuthorizationInfo, Never>
}

typealias LoginViewModelOutput = AnyPublisher<LoginState, Never>

// MARK: - LoginState

enum LoginState {
  case idle
}

// MARK: - LoginViewModel

final class LoginViewModel {
  private var subscriptions: Set<AnyCancellable> = []

  private let authorizeUseCase: AuthorizeUseCaseRepresentable

  init(authorizeUseCase: AuthorizeUseCaseRepresentable) {
    self.authorizeUseCase = authorizeUseCase
  }
}

// MARK: LoginViewModelRepresentable

extension LoginViewModel: LoginViewModelRepresentable {
  func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
    input.appleLoginButtonDidTap
      .flatMap(authorizeUseCase.authorize(authorizationInfo:))
      .sink(receiveValue: { _ in
        // TODO: keychainRepository에 토큰 저장하는 로직
      })
      .store(in: &subscriptions)

    let idle = Just(LoginState.idle)
      .eraseToAnyPublisher()

    return idle
  }
}

// MARK: - LoginViewModelRepresentable

protocol LoginViewModelRepresentable {
  func transform(input: LoginViewModelInput) -> LoginViewModelOutput
}
