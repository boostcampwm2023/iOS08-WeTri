//
//  RefreshTokenAdaptor.swift
//  CommonNetworkingKeyManager
//
//  Created by MaraMincho on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Keychain
import Trinet

public final class RefreshTokenAdaptor: TNRequestInterceptor {
  public init() {}

  public func retry(
    _: URLRequest,
    session _: URLSessionProtocol,
    data: Data,
    response: URLResponse,
    delegate _: URLSessionDelegate?
  ) async throws -> (Data, URLResponse) {
    return (data, response)
  }

  public func adapt(_ request: URLRequest, session _: URLSessionProtocol) -> URLRequest {
    var mutatbleRequest = request
    if let refreshToken = RefreshTokenManager.refreshToken {
      let headerValue = "Bearer \(refreshToken)"
      mutatbleRequest.setValue(headerValue, forHTTPHeaderField: "authorization")
    }
    return mutatbleRequest
  }

  enum RefreshTokenManager {
    static var refreshToken: String? {
      guard
        let refreshTokenData = Keychain.shared.load(key: Tokens.refreshToken),
        let refreshToken = String(data: refreshTokenData, encoding: .utf8)
      else {
        return nil
      }
      return refreshToken
    }
  }
}
