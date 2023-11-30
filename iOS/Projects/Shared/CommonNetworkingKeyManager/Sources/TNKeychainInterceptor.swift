//
//  TNKeychainInterceptor.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 11/30/23.
//

import Foundation
import Keychain
import Log
import Trinet

// MARK: - TNKeychainInterceptor

public final class TNKeychainInterceptor {
  private let decoder = JSONDecoder()
  public static let shared = TNKeychainInterceptor()
  private init() {}
}

// MARK: TNRequestInterceptor

extension TNKeychainInterceptor: TNRequestInterceptor {
  public func adapt(_ request: URLRequest, session _: URLSessionProtocol) -> URLRequest {
    addAccessToken(request: request)
  }

  func addAccessToken(request: URLRequest) -> URLRequest {
    guard let accessToken = TNKeyChainManager.accessToken else {
      return request
    }
    var mutatableRequest = request
    mutatableRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")

    return mutatableRequest
  }

  public func retry(
    _ request: URLRequest,
    session: URLSessionProtocol,
    data: Data,
    response: URLResponse,
    delegate _: URLSessionDelegate?
  ) async throws -> (Data, URLResponse) {
    let code = try decoder.decode(GWResponse<String?>.self, from: data).code
    if code == 401 {
      try await refreshAccessToken(session: session)
      try await refreshRefreshToken(session: session)
      return try await session.data(for: addAccessToken(request: request), delegate: nil)
    }

    return (data, response)
  }
}

private extension TNKeychainInterceptor {
  enum RefreshEndPoint: TNEndPoint {
    case refreshAccessToken
    case refreshRefreshToken
    var path: String {
      switch self {
      case .refreshAccessToken:
        return "api/v1/auth/token/access"
      case .refreshRefreshToken:
        return "api/v1/auth/token/refresh"
      }
    }

    var method: TNMethod { .post }
    var query: Encodable? { nil }
    var body: Encodable? { nil }
    var headers: TNHeaders { .default }
  }

  func refreshAccessToken(session: URLSessionProtocol) async throws {
    let provider = TNProvider<RefreshEndPoint>(session: session)
    let data = try await provider.request(.refreshAccessToken, interceptor: RefreshTokenAdaptor())
    let gwResponse = try JSONDecoder().decode(GWResponse<RefreshAccessTokenResponse>.self, from: data)
    guard
      let token = gwResponse.data?.accessToken,
      let tokenData = token.data(using: .utf8)
    else {
      throw TNError.serverError
    }

    Keychain.shared.save(key: Tokens.accessToken, data: tokenData)
  }

  func refreshRefreshToken(session: URLSessionProtocol) async throws {
    let provider = TNProvider<RefreshEndPoint>(session: session)
    let data = try await provider.request(.refreshRefreshToken, interceptor: RefreshTokenAdaptor())
    let gwResponse = try JSONDecoder().decode(GWResponse<RefreshRefreshTokenResponse>.self, from: data)
    guard
      let token = gwResponse.data?.refreshToken,
      let tokenData = token.data(using: .utf8)
    else {
      throw TNError.serverError
    }

    Keychain.shared.save(key: Tokens.refreshToken, data: tokenData)
  }

  enum TNKeyChainManager {
    static var accessToken: String? {
      guard
        let accessTokenData = Keychain.shared.load(key: Tokens.accessToken),
        let accessToken = String(data: accessTokenData, encoding: .utf8)
      else {
        return nil
      }
      return accessToken
    }
  }
}

// MARK: - RefreshAccessTokenResponse

struct RefreshAccessTokenResponse: Decodable {
  let accessToken: String
}

// MARK: - RefreshRefreshTokenResponse

struct RefreshRefreshTokenResponse: Decodable {
  let refreshToken: String
}
