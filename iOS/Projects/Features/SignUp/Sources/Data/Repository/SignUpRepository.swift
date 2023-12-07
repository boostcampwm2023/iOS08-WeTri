//
//  SignUpRepository.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log
import Trinet

// MARK: - SignUpRepositoryError

enum SignUpRepositoryError: Error {
  case invalidData
}

// MARK: - SignUpRepository

public struct SignUpRepository: SignUpRepositoryRepresentable {
  private let provider: TNProvider<SignUpRepositoryEndPoint>

  init(urlSession: URLSessionProtocol) {
    provider = TNProvider(session: urlSession)
  }

  public func signUp(signUpUser: SignUpUser) -> AnyPublisher<Token, Error> {
    return Future<Data, Never> { promise in
      Task {
        do {
          let data = try await provider.request(.signup(signUpUser))
          promise(.success(data))
        } catch {
          Log.make().error("\(error)")
        }
      }
    }
    .decode(type: GWResponse<Token>.self, decoder: JSONDecoder())
    .compactMap(\.data)
    .eraseToAnyPublisher()
  }
}

// MARK: - SignUpRepositoryEndPoint

private enum SignUpRepositoryEndPoint: TNEndPoint {
  case signup(SignUpUser)

  var path: String {
    switch self {
    case .signup:
      return "/api/v1/auth/signup"
    }
  }

  var method: TNMethod {
    switch self {
    case .signup:
      return .post
    }
  }

  var query: Encodable? {
    return nil
  }

  var body: Encodable? {
    switch self {
    case let .signup(signUpUser):
      return signUpUser
    }
  }

  var headers: TNHeaders {
    []
  }
}
