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

public struct LoginViewModelInput {
  public let credential: AnyPublisher<AuthorizationInfo, Never>
  public let appleLoginButtonDidTap: AnyPublisher<Void, Never>

  public init(
    credential: AnyPublisher<AuthorizationInfo, Never>,
    appleLoginButtonDidTap: AnyPublisher<Void, Never>
  ) {
    self.credential = credential
    self.appleLoginButtonDidTap = appleLoginButtonDidTap
  }
}

public typealias LoginViewModelOutput = AnyPublisher<LoginState, Never>

// MARK: - LoginState

public enum LoginState {
  case idle
  case success
  case customError(Error)
}

// MARK: - LoginViewModel

public final class LoginViewModel {
  private var subscriptions: Set<AnyCancellable> = []

  private let authorizeUseCase: AuthorizeUseCaseRepresentable

  public init(authorizeUseCase: AuthorizeUseCaseRepresentable) {
    self.authorizeUseCase = authorizeUseCase
  }
}

// MARK: LoginViewModelRepresentable

extension LoginViewModel: LoginViewModelRepresentable {
  public func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
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

public protocol LoginViewModelRepresentable {
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
