//
//  SplashUseCase.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Keychain
import Log

// MARK: - SplashUseCase

public struct SplashUseCase: SplashUseCaseRepresentable {
  private let repository: SplashTokenRepositoryRepresentable

  public init(repository: SplashTokenRepositoryRepresentable) {
    self.repository = repository
  }

  public func reissueToken() -> AnyPublisher<Bool, Never> {
    return repository.reissueRefreshToken()
      .map(\.refreshToken)
      .tryMap {
        Log.make().debug("refresh token: \($0)")
        guard let data = $0.data(using: .utf8) else {
          throw SplashUseCaseError.cannotData
        }
        return data
      }
      .map { refreshTokenData in
        Keychain.shared.delete(key: Tokens.refreshToken)
        Keychain.shared.save(key: Tokens.refreshToken, data: refreshTokenData)
      }
      .flatMap(repository.reissueAccessToken)
      .map(\.accessToken)
      .tryMap {
        Log.make().debug("access token: \($0)")
        guard let data = $0.data(using: .utf8) else {
          throw SplashUseCaseError.cannotData
        }
        return data
      }
      .map { accessTokenData in
        Keychain.shared.delete(key: Tokens.accessToken)
        Keychain.shared.save(key: Tokens.accessToken, data: accessTokenData)
      }
      .map { return true } // 모든 로직이 성공
      .catch { _ in Just(false) } // Error가 발생하면 false 리턴
      .eraseToAnyPublisher()
  }
}

// MARK: - SplashUseCaseError

private enum SplashUseCaseError: Error {
  case cannotData
}
