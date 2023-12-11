//
//  SplashUseCase.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - SplashUseCase

public struct SplashUseCase: SplashUseCaseRepresentable {
  private let repository: SplashTokenRepositoryRepresentable
  private let persistencyRepository: PersistencyRepositoryRepresentable

  public init(repository: SplashTokenRepositoryRepresentable, persistencyRepository: PersistencyRepositoryRepresentable) {
    self.repository = repository
    self.persistencyRepository = persistencyRepository
  }

  /// 토큰을 재발급받습니다.
  /// - Returns: 토큰 재발급시 True, 실패시 False를 리턴하는 Publisher
  ///
  /// - Description:
  ///   repository에서 `refresh token` 재발급과 `access token` 재발급을 요청합니다.
  ///   모든 토큰을 재발급받는 과정을 UseCase 메서드 하나로 둔 이유는, 비즈니스 로직에서 담당하는 게 맞다고 생각했기 때문입니다.
  ///   물론 이를 두 개의 메서드로 나누어 ViewModel에서 연결해주어도 상관 없습니다.
  public func reissueToken() -> AnyPublisher<Bool, Never> {
    return repository.reissueRefreshToken()
      .map(\.refreshToken)
      .tryMap {
        guard let data = $0.data(using: .utf8) else {
          throw SplashUseCaseError.cannotData
        }
        return data
      }
      .map { refreshTokenData in
        persistencyRepository.saveRefreshToken(refreshToken: refreshTokenData)
      }
      .flatMap(repository.reissueAccessToken)
      .map(\.accessToken)
      .tryMap {
        guard let data = $0.data(using: .utf8) else {
          throw SplashUseCaseError.cannotData
        }
        return data
      }
      .map { accessTokenData in
        persistencyRepository.saveAccessToken(accessToken: accessTokenData)
        persistencyRepository.reissueUserProfileInformation()
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
