//
//  AuthorizeUseCase.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Log
import UserInformationManager

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

  func authorize(authorizationInfo: AuthorizationInfo) -> AnyPublisher<LoginResponse, Never> {
    return authorizationRepository.fetch(authorizationInfo: authorizationInfo)
      .eraseToAnyPublisher()
  }

  func accessTokenSave(_ token: String) {
    keychainRepository.save(key: Tokens.accessToken, value: token)
    UserInformationFetcher().reissueUserProfileInformation()
  }

  func refreshTokenSave(_ token: String) {
    keychainRepository.save(key: Tokens.refreshToken, value: token)
  }
}
