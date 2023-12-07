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
  let credential: AnyPublisher<AuthorizationInfo, Never>
  let appleLoginButtonDidTap: AnyPublisher<Void, Never>
}

typealias LoginViewModelOutput = AnyPublisher<LoginState, Never>

// MARK: - LoginState

enum LoginState {
  case idle
  case success
  case customError(Error)
}

// MARK: - LoginViewModel

final class LoginViewModel {
  private var subscriptions: Set<AnyCancellable> = []

  private let coordinator: LoginCoordinating
  private let authorizeUseCase: AuthorizeUseCaseRepresentable

  init(
    coordinator: LoginCoordinating,
    authorizeUseCase: AuthorizeUseCaseRepresentable
  ) {
    self.coordinator = coordinator
    self.authorizeUseCase = authorizeUseCase
  }
}

// MARK: LoginViewModelRepresentable

extension LoginViewModel: LoginViewModelRepresentable {
  func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
    input.credential
      .flatMap(authorizeUseCase.authorize(authorizationInfo:))
      .sink(receiveValue: { [weak self] token in
        guard let accessToken = token.accesToken,
              let refreshToken = token.refreshToken
        else {
          return
        }
        self?.authorizeUseCase.accessTokenSave(accessToken)
        self?.authorizeUseCase.refreshTokenSave(refreshToken)
      })
      .store(in: &subscriptions)

    let login = input.appleLoginButtonDidTap
      .flatMap { _ -> LoginViewModelOutput in
        return Just(.success)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    let idle: LoginViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    return Publishers
      .Merge(idle, login)
      .eraseToAnyPublisher()
  }
}

// MARK: - LoginViewModelRepresentable

protocol LoginViewModelRepresentable {
  func transform(input: LoginViewModelInput) -> LoginViewModelOutput
}

// MARK: - LoginViewModelError

enum LoginViewModelError: Error {
  case invalidToken
}

// MARK: LocalizedError

extension LoginViewModelError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidToken:
      return "토큰이 존재하지 않습니다."
    }
  }
}
