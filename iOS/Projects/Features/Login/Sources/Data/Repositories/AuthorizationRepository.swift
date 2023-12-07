//
//  AuthorizationRepository.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log
import Trinet

// MARK: - AuthorizationRepositoryError

enum AuthorizationRepositoryError: Error {
  case invalidData
  case failureDecode
}

// MARK: - AuthorizationRepository

struct AuthorizationRepository: AuthorizationRepositoryRepresentable {
  private let provider: TNProvider<AuthorizationRepositoryEndPoint>
  private let decoder = JSONDecoder()

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  func fetch(authorizationInfo: AuthorizationInfo) -> AnyPublisher<LoginResponse, Never> {
    return Future<LoginResponse, Never> { promise in
      Task {
        do {
          guard let token = String(data: authorizationInfo.identityToken, encoding: .utf8),
                let authorizationCode = String(data: authorizationInfo.authorizationCode, encoding: .utf8)
          else {
            return
          }
          let authorizationInfoRequestDTO = AuthorizationInfoRequestDTO(identityToken: token, authorizationCode: authorizationCode)

          let data = try await provider.request(.signIn(authorizationInfoRequestDTO))

          guard let responseCode = try decoder.decode(Response.self, from: data).code else {
            return
          }
          switch responseCode {
          case AuthorizationRepositoryResponseCode.token.code:
            let token = try decoder.decode(GWResponse<Token>.self, from: data).data
            promise(.success((token, nil)))
          case AuthorizationRepositoryResponseCode.firstLogin.code:
            let initialUser = try decoder.decode(GWResponse<InitialUser>.self, from: data).data
            promise(.success((nil, initialUser)))
          default: break
          }
        } catch {
          Log.make().error("\(error)")
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - AuthorizationRepositoryEndPoint

enum AuthorizationRepositoryEndPoint: TNEndPoint {
  /// Property
  case signIn(AuthorizationInfoRequestDTO)

  var path: String {
    switch self {
    case .signIn:
      return "auth/apple/signin"
    }
  }

  var method: TNMethod {
    switch self {
    case .signIn:
      return .post
    }
  }

  var query: Encodable? {
    return nil
  }

  var body: Encodable? {
    switch self {
    case let .signIn(authorizationInfo):
      return authorizationInfo
    }
  }

  var headers: TNHeaders {
    return .init(headers: [
      // TODO: 헤더 설정
    ])
  }
}

// MARK: - AuthorizationRepositoryResponseCode

enum AuthorizationRepositoryResponseCode: Int {
  case token
  case firstLogin

  var code: Int {
    switch self {
    case .token:
      return 200
    case .firstLogin:
      return 201
    }
  }
}
