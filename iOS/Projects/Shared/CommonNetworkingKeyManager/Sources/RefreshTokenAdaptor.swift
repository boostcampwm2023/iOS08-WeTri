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

final class RefreshTokenAdaptor: TNRequestInterceptor {
  func retry(_: URLRequest, session _: URLSessionProtocol, data: Data, response: URLResponse, delegate _: URLSessionDelegate?) async throws -> (Data, URLResponse) {
    return (data, response)
  }

  func adapt(_ request: URLRequest, session _: URLSessionProtocol) -> URLRequest {
    var mutatbleRequest = request
    if let refreshToken = RefreshTokenManager.refreshToken {
      let headerValue = "Bearer \(refreshToken)"
      mutatbleRequest.addValue(headerValue, forHTTPHeaderField: "authorization")
    }
    return mutatbleRequest
  }

  enum RefreshTokenManager {
    static var refreshToken: String? {
      guard
        let accessTokenData = Keychain.shared.load(key: "refreshToken"),
        let accessToken = String(data: accessTokenData, encoding: .utf8)
      else {
        return nil
      }
      return accessToken
    }
  }
}
