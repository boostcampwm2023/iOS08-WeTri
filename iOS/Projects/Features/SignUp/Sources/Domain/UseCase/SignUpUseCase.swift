//
//  SignUpUseCase.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Combine
import CommonNetworkingKeyManager
import Foundation

// MARK: - SignUpUseCaseRepresentable

public protocol SignUpUseCaseRepresentable {
  func signUp(signUpUser: SignUpUser) -> AnyPublisher<Token, Error>
  func accessTokenSave(_ token: String)
  func refreshTokenSave(_ token: String)
}

// MARK: - SignUpUseCase

public final class SignUpUseCase: SignUpUseCaseRepresentable {
  private let signUpRepository: SignUpRepositoryRepresentable
  private let keychainRepository: KeychainRepositoryRepresentable

  public init(
    signUpRepository: SignUpRepositoryRepresentable,
    keychainRepository: KeychainRepositoryRepresentable
  ) {
    self.signUpRepository = signUpRepository
    self.keychainRepository = keychainRepository
  }

  public func signUp(signUpUser: SignUpUser) -> AnyPublisher<Token, Error> {
    return signUpRepository.signUp(signUpUser: signUpUser)
      .eraseToAnyPublisher()
  }

  public func accessTokenSave(_ token: String) {
    keychainRepository.save(key: Tokens.accessToken, value: token)
  }

  public func refreshTokenSave(_ token: String) {
    keychainRepository.save(key: Tokens.refreshToken, value: token)
  }
}
