//
//  AuthorizeUseCase.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - AuthorizeUseCase

final class AuthorizeUseCase: AuthorizeUseCaseRepresentable {
  private let authorizationRepository: AuthorizationRepositoryRepresentable
  private let keychainRepository: KeychainRepositoryRepresentable

  init(
    authorizationRepository: AuthorizationRepositoryRepresentable,
    keychainRepository: KeychainRepositoryRepresentable
  ) {
    self.authorizationRepository = authorizationRepository
    self.keychainRepository = keychainRepository
  }

  func authorize(authorizationInfo: AuthorizationInfo) -> AnyPublisher<Token, Never> {
    return authorizationRepository.fetch(authorizationInfo: authorizationInfo)
      .eraseToAnyPublisher()
  }

  func accessTokenSave(_ token: Data) {
    keychainRepository.save(key: Keys.accessToken, data: token)
  }

  func refreshTokenSave(_ token: Data) {
    keychainRepository.save(key: Keys.refreshToken, data: token)
  }
}

// MARK: - Keys

private enum Keys {
  static let accessToken = "accessToken"
  static let refreshToken = "refreshToken"
}
