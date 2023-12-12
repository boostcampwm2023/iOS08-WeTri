//
//  SignUpRepository.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Combine
import Foundation
import Log
import Trinet

// MARK: - SignUpRepositoryError

enum SignUpRepositoryError: Error {
  case invalidData
  case invalidDuplicate
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

  public func duplicateTest(nickName: String) -> AnyPublisher<Bool, Never> {
    return Future<Bool, Error> { promise in
      Task {
        do {
          let (_, response) = try await provider.requestResponse(.duplicate(NickNameDuplicateRequestDTO(nickname: nickName)))
          guard let httpResponse = response as? HTTPURLResponse else {
            return promise(.success(false))
          }
          switch httpResponse.statusCode {
          // 중복이 아닌 경우
          case 201:
            promise(.success(false))
            return
          // 중복인 경우
          case 202:
            promise(.success(true))
            return
          default:
            promise(.failure(SignUpRepositoryError.invalidDuplicate))
            return
          }
        } catch {
          Log.make().error("\(error)")
          promise(.failure(error))
        }
      }
    }
    .catch { error in
      Log.make().error("\(error)")
      return Empty<Bool, Never>()
    }
    .map { result in
      return result
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - SignUpRepositoryEndPoint

private enum SignUpRepositoryEndPoint: TNEndPoint {
  case signup(SignUpUser)
  case duplicate(NickNameDuplicateRequestDTO)

  var path: String {
    switch self {
    case .signup:
      return "/api/v1/auth/signup"
    case .duplicate:
      return "/api/v1/profiles/nickname-availability"
    }
  }

  var method: TNMethod {
    switch self {
    case .signup:
      return .post
    case .duplicate:
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
    case let .duplicate(nickName):
      return nickName
    }
  }

  var headers: TNHeaders {
    return .default
  }
}
