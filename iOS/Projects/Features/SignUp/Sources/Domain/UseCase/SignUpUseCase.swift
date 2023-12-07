//
//  SignUpUseCase.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - SignUpUseCaseRepresentable

protocol SignUpUseCaseRepresentable {
  func signUp(signUpUser: SignUpUser) -> AnyPublisher<Token, Error>
}

// MARK: - SignUpUseCase

final class SignUpUseCase: SignUpUseCaseRepresentable {
  private let signUpRepository: SignUpRepositoryRepresentable
  private let keychainRepository: KeychainRepositoryRepresentable

  init(
    signUpRepository: SignUpRepositoryRepresentable,
    keychainRepository: KeychainRepositoryRepresentable
  ) {
    self.signUpRepository = signUpRepository
    self.keychainRepository = keychainRepository
  }

  func signUp(signUpUser: SignUpUser) -> AnyPublisher<Token, Error> {
    return signUpRepository.signUp(signUpUser: signUpUser)
      .eraseToAnyPublisher()
  }

  func accessTokenSave(_ token: String) {
    keychainRepository.save(key: Keys.accessToken, value: token)
  }

  func refreshTokenSave(_ token: String) {
    keychainRepository.save(key: Keys.refreshToken, value: token)
  }
}

// MARK: - Keys

private enum Keys {
  static let accessToken = "accessToken"
  static let refreshToken = "refreshToken"
}
