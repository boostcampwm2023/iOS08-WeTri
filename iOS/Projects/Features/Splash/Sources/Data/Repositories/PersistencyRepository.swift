//
//  PersistencyRepository.swift
//  SplashFeature
//
//  Created by MaraMincho on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Keychain
import Trinet
import UserInformationManager

// MARK: - PersistencyRepository

struct PersistencyRepository: PersistencyRepositoryRepresentable {
  private let provider: TNProvider<ProfileFetch>

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  func saveAccessToken(accessToken: Data) {
    Keychain.shared.delete(key: Tokens.accessToken)
    Keychain.shared.save(key: Tokens.accessToken, data: accessToken)
  }

  func saveRefreshToken(refreshToken: Data) {
    Keychain.shared.delete(key: Tokens.refreshToken)
    Keychain.shared.save(key: Tokens.refreshToken, data: refreshToken)
  }
}

// MARK: - ProfileFetch

private enum ProfileFetch: TNEndPoint {
  case fetchProfile

  var path: String {
    switch self {
    case .fetchProfile:
      return "/api/v1/profiles/me"
    }
  }

  var method: TNMethod { .get }
  var query: Encodable? { nil }
  var body: Encodable? { nil }
  var headers: TNHeaders { .default }
}

// MARK: - TokenError

private enum TokenError: Error {
  case noData
}
