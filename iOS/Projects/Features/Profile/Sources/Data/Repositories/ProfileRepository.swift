//
//  ProfileRepository.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Trinet

// MARK: - ProfileRepository

public struct ProfileRepository {
  private let provider: TNProvider<ProfileEndPoint>
  private let jsonDecoder: JSONDecoder = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" // JSON의 날짜 형식에 맞춰 설정합니다.
    dateFormatter.locale = Locale(identifier: "ko_KR")

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()

  // MARK: Initializations

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }
}

// MARK: ProfileRepositoryRepresentable

extension ProfileRepository: ProfileRepositoryRepresentable {
  public func fetchProfiles() -> AnyPublisher<Profile, Error> {
    return Deferred {
      Future<Data, Error> { promise in
        Task {
          do {
            let data = try await provider.request(.fetchProfile, interceptor: TNKeychainInterceptor.shared)
            promise(.success(data))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .decode(type: GWResponse<ProfileDTO>.self, decoder: jsonDecoder)
    .compactMap(\.data)
    .tryMap {
      try Profile(profileData: Data(contentsOf: $0.profileImage), nickname: $0.nickname)
    }
    .eraseToAnyPublisher()
  }

  public func fetchPosts(nextID: Int?) -> AnyPublisher<PostsResponseDTO, Error> {
    return Deferred {
      Future<Data, Error> { promise in
        Task {
          do {
            let data = try await provider.request(
              .fetchPosts(.init(idLessThan: nil, idMoreThan: nextID, orderCreatedAt: .descending, limit: 20)),
              interceptor: TNKeychainInterceptor.shared
            )
            promise(.success(data))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .decode(type: GWResponse<PostsResponseDTO>.self, decoder: jsonDecoder)
    .compactMap(\.data)
    .eraseToAnyPublisher()
  }
}

// MARK: - ProfileEndPoint

private enum ProfileEndPoint {
  case fetchProfile
  case fetchPosts(PostsRequestDTO)
}

// MARK: TNEndPoint

extension ProfileEndPoint: TNEndPoint {
  var path: String {
    switch self {
    case .fetchProfile:
      return "/api/v1/profiles/me"
    case .fetchPosts:
      return "/api/v1/profiles/me/posts"
    }
  }

  var method: TNMethod {
    .get
  }

  var query: Encodable? {
    switch self {
    case .fetchProfile:
      return nil
    case let .fetchPosts(model):
      return model
    }
  }

  var body: Encodable? {
    nil
  }

  var headers: TNHeaders {
    .default
  }
}
