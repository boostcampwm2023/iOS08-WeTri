//
//  LogoutUseCase.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Log

// MARK: - AuthorizeUseCase

final class LogoutUseCase: LogoutUseCaseRepresentable {
  private let keychainRepository: KeychainRepositoryRepresentable

  init(
    keychainRepository: KeychainRepositoryRepresentable
  ) {
    self.keychainRepository = keychainRepository
  }

  func logout() -> AnyPublisher<Bool, Never> {
    keychainRepository.delete(key: Tokens.accessToken)
      .combineLatest(keychainRepository.delete(key: Tokens.refreshToken))
      .map { _ in true } // 삭제 성공 시 true
      .catch { _ in Just(false) } // 실패 시 false
      .eraseToAnyPublisher()
  }
}
