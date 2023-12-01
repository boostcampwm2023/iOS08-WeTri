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
      Log.make().error("AccessToken이 KeyChain에 저장되어있지 않아서, Header에 토큰을 동봉하지 못했습니다.")
      return request
    }
    var mutatableRequest = request
    mutatableRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    return mutatableRequest
  }

  public func retry(
    _ request: URLRequest,
    session: URLSessionProtocol,
    data: Data,
    response: URLResponse,
    delegate _: URLSessionDelegate?
  ) async throws -> (Data, URLResponse) {
    let code = try decoder.decode(GWResponseForStatusCode.self, from: data).code
    if code == 1030 {
      Log.make().debug("AccessToken이 만료되어, Retry를 진행합니다.")
      try await refreshAccessToken(session: session)
      try await refreshRefreshToken(session: session)
      let (retriedData, retriedResponse) = try await session.data(for: addAccessToken(request: request), delegate: nil)
      return (retriedData, retriedResponse)
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
    Log.make().debug("리프레시 토큰을 통해 엑세스 토큰을 가져오는 작업을 시작합니다.")
    let provider = TNProvider<RefreshEndPoint>(session: session)
    let data = try await provider.request(.refreshAccessToken, interceptor: RefreshTokenAdaptor())
    let gwResponse = try JSONDecoder().decode(GWResponse<RefreshAccessTokenResponse>.self, from: data)
    guard
      let token = gwResponse.data?.accessToken,
      let tokenData = token.data(using: .utf8)
    else {
      Log.make().error("리프레시 토큰을 통해 엑세스 토큰을 가져오는 작업을 실패했습니다.")
      throw TNError.serverError
    }
    Keychain.shared.delete(key: Tokens.accessToken)
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
      Log.make().error("리프레시 토큰을 통해 리프레시 토큰을 가져오는 작업을 실패했습니다.")
      throw TNError.serverError
    }
    Log.make().debug("정상적으로 retry요청을 통해서 refreshToken을 받아왔습니다. ")
    Keychain.shared.delete(key: Tokens.refreshToken)
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
