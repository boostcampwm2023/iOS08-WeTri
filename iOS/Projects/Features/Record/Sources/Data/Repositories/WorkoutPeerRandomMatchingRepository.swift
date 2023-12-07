//
//  WorkoutPeerRandomMatchingRepository.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Log
import Trinet

// MARK: - WorkoutPeerRandomMatchingRepository

struct WorkoutPeerRandomMatchingRepository {
  private let provider: TNProvider<WorkoutPeerRandomMatchingRepositoryEndPoint>
  private let decoder = JSONDecoder()
  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }
}

// MARK: WorkoutPeerRandomMatchingRepositoryRepresentable

extension WorkoutPeerRandomMatchingRepository: WorkoutPeerRandomMatchingRepositoryRepresentable {
  func matchStart(workoutTypeCode: Int) -> AnyPublisher<Result<Void, Error>, Never> {
    return Future<Result<Void, Error>, Never> { promise in
      Task {
        do {
          let data = try await provider.request(
            .matchStart(
              matchStartRequest: .init(workoutID: workoutTypeCode)),
            interceptor: TNKeychainInterceptor.shared
          )
          _ = try decoder.decode(GWResponse<NullDTO>.self, from: data)
          promise(.success(.success(())))
        } catch {
          promise(.success(.failure(error)))
        }
      }
    }.eraseToAnyPublisher()
  }

  func matchCancel() {
    Task {
      do {
        let _ = try await provider.request(.matchCancel, interceptor: TNKeychainInterceptor.shared)
      } catch {
        // TODO: ERROR Handling
      }
    }
  }

  func isMatchedRandomPeer(
    isMatchedRandomPeersRequest: IsMatchedRandomPeersRequest
  ) -> AnyPublisher<Result<IsMatchedRandomPeersResponse?, Error>, Never> {
    return Future<Result<IsMatchedRandomPeersResponse?, Error>, Never> { promise in
      Task {
        do {
          let data = try await provider.request(
            .isMatchedRandomPeer(isMatchedRandomPeersRequest: isMatchedRandomPeersRequest),
            interceptor: TNKeychainInterceptor.shared
          )
          guard
            let responseData = try decoder.decode(GWResponse<IsMatchedRandomPeersResponse>.self, from: data).data
          else {
            throw RepositoryError.serverError
          }
          promise(.success(.success(responseData)))
        } catch {
          promise(.success(.failure(error)))
        }
      }
    }.eraseToAnyPublisher()
  }
}

// MARK: - RepositoryError

enum RepositoryError: LocalizedError {
  case serverError
  case unkwonError
}

// MARK: - WorkoutPeerRandomMatchingRepository.WorkoutPeerRandomMatchingRepositoryEndPoint

extension WorkoutPeerRandomMatchingRepository {
  enum WorkoutPeerRandomMatchingRepositoryEndPoint: TNEndPoint {
    /// Property
    case matchStart(matchStartRequest: MatchStartRequest)
    case matchCancel
    case isMatchedRandomPeer(isMatchedRandomPeersRequest: IsMatchedRandomPeersRequest)

    /// TNEndPoint
    var path: String {
      switch self {
      case .matchStart:
        return "api/v1/matches/start"
      case .matchCancel:
        return "api/v1/matches/cancel"
      case .isMatchedRandomPeer:
        return "api/v1/matches/random"
      }
    }

    var method: TNMethod {
      switch self {
      case .isMatchedRandomPeer,
           .matchStart:
        return .post
      case .matchCancel:
        return .delete
      }
    }

    var query: Encodable? {
      return nil
    }

    var body: Encodable? {
      switch self {
      case let .matchStart(matchStartRequest): return matchStartRequest
      case let .isMatchedRandomPeer(isMatchedRandomPeersRequest): return isMatchedRandomPeersRequest
      case .matchCancel: return nil
      }
    }

    var headers: TNHeaders {
      .default
    }
  }
}
