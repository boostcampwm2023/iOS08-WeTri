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

public struct AuthorizationRepository: AuthorizationRepositoryRepresentable {
  private let provider: TNProvider<AuthorizationRepositoryEndPoint>
  private let decoder = JSONDecoder()

  public init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  public func fetch(authorizationInfo: AuthorizationInfo) -> AnyPublisher<Token, Never> {
    return Future<Data, Never> { promise in
      Task {
        let identityToken = try decoder.decode(String.self, from: authorizationInfo.identityToken)
        let authorizationCode = try decoder.decode(String.self, from: authorizationInfo.authorizationCode)
        let authorizationInfoRequestDTO = AuthorizationInfoRequestDTO(identityToken: identityToken, authorizationCode: authorizationCode)

        let data = try await provider.request(.signIn(authorizationInfoRequestDTO))
        promise(.success(data))
      }
    }
    .decode(type: GWResponse<Token>.self, decoder: decoder)
    .tryMap { response in
      if response.code == 200 {
        guard let token = response.data else {
          throw AuthorizationRepositoryError.invalidData
        }
        return token
      } else {
        // TODO: 백엔드와 상의 후 에러코드 처리
        throw AuthorizationRepositoryError.invalidData
      }
    }
    .catch { error -> AnyPublisher<Token, Never> in
      Log.make().error("\(error)")
      return Just(Token())
        .eraseToAnyPublisher()
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
