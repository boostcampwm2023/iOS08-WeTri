//
//  AuthorizationRepository.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import OSLog
import Trinet

// MARK: - AuthorizationRepositoryError

enum AuthorizationRepositoryError: Error {
  case invalidData
  case failureDecode
  case deinitializedRepository
}

// MARK: - AuthorizationRepository

final class AuthorizationRepository: AuthorizationRepositoryRepresentable {
  private let provider: TNProvider<AuthorizationRepositoryEndPoint>
  private let decoder = JSONDecoder()

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  func fetch(authorizationInfo: AuthorizationInfo) -> AnyPublisher<Token, Never> {
    return Future<Token, Error> { [weak self] promise in
      guard let self else {
        return promise(.failure(AuthorizationRepositoryError.deinitializedRepository))
      }
      Task {
        let identityToken = try self.decoder.decode(String.self, from: authorizationInfo.identityToken)
        let authorizationCode = try self.decoder.decode(String.self, from: authorizationInfo.authorizationCode)
        let authorizationInfoRequestDTO = AuthorizationInfoRequestDTO(identityToken: identityToken, authorizationCode: authorizationCode)

        let data = try await self.provider.request(.signIn(authorizationInfoRequestDTO))
        let response = try self.decoder.decode(GWResponse<Token>.self, from: data)

        if response.code == 200 {
          guard let token = response.data else {
            return promise(.failure(AuthorizationRepositoryError.invalidData))
          }
          promise(.success(token))
        }
        // TODO: 백엔드와 상의 후 에러코드 처리
      }
    }
    .catch { error -> AnyPublisher<Token, Never> in
      if let authorizationError = error as? AuthorizationRepositoryError {
        Logger().error("\(authorizationError)")
      }
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
