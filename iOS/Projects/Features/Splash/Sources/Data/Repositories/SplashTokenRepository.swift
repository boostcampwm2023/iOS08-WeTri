//
//  SplashTokenRepository.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Trinet
import UserInformationManager

// MARK: - SplashTokenRepository

public struct SplashTokenRepository: SplashTokenRepositoryRepresentable {
  private let provider: TNProvider<ReissueEndPoint>
  private let jsonDecoder: JSONDecoder = .init()

  public init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  public func reissueAccessToken() -> AnyPublisher<ReissueAccessTokenDTO, Error> {
    Future<Data, Error> { promise in
      Task {
        do {
          let data = try await provider.request(.accessToken, interceptor: RefreshTokenAdaptor())
          promise(.success(data))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .decode(type: GWResponse<ReissueAccessTokenDTO>.self, decoder: jsonDecoder)
    .tryMap {
      guard let response = $0.data else {
        throw TokenError.noData
      }
      return response
    }
    .eraseToAnyPublisher()
  }

  public func reissueRefreshToken() -> AnyPublisher<ReissueRefreshTokenDTO, Error> {
    Future<Data, Error> { promise in
      Task {
        do {
          let data = try await provider.request(.refreshToken, interceptor: RefreshTokenAdaptor())
          promise(.success(data))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .decode(type: GWResponse<ReissueRefreshTokenDTO>.self, decoder: jsonDecoder)
    .tryMap {
      guard let response = $0.data else {
        throw TokenError.noData
      }
      return response
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - ReissueEndPoint

private enum ReissueEndPoint: TNEndPoint {
  case accessToken
  case refreshToken

  var path: String {
    switch self {
    case .accessToken:
      return "api/v1/auth/token/access"
    case .refreshToken:
      return "api/v1/auth/token/refresh"
    }
  }

  var method: TNMethod { .post }
  var query: Encodable? { nil }
  var body: Encodable? { nil }
  var headers: TNHeaders { .default }
}

// MARK: - TokenError

private enum TokenError: Error {
  case noData
}
