//
//  WorkoutPeerRandomMatchingRepository.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
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
  func matcheStart(workoutTypeCode: Int) -> AnyPublisher<Result<Void, Error>, Never> {
    return Future<Result<Void, Error>, Never> { promise in
      Task {
        do {
          let data = try await provider.request(.matchStart(workoutTypeCode: workoutTypeCode))
          // TODO: 어차피 Nil인데, optional로해야할지 아니면 그냥 할지 고민
          // GWResponse<NullDTO>.self, GWResponse<NullDTO?>.self
          let response = try decoder.decode(GWResponse<NullDTO>.self, from: data)
          if 200 ... 300 ~= (response.code ?? 404) { // 200번대 REsponse인지 확인, 보통 서버에서 코드를 보내주지만, 안보내줄 경우 자동적으로 동작 안하게 작성)
            promise(.success(.success(())))
          } else {
            // TODO: ERROR Handling
            promise(.success(.failure(RepositoryError.serverError)))
          }
        } catch {
          promise(.success(.failure(error)))
        }
      }
    }.eraseToAnyPublisher()
  }

  func matchCancel() {
    Task {
      do {
        let _ = try await provider.request(.matchCancel)
      } catch {
        // TODO: ERROR Handling
      }
    }
  }

  func isMatchedRandomPeer(workoutTypeCode: Int) -> AnyPublisher<Result<PeerMatchResponseDTO?, Error>, Never> {
    return Future<Result<PeerMatchResponseDTO?, Error>, Never> { promise in
      Task {
        do {
          let data = try await provider.request(.isMatchedRandomPeer(workoutTypeCode: workoutTypeCode))
          let response = try decoder.decode(GWResponse<PeerMatchResponseDTO>.self, from: data)
          if response.code == 201 {
            promise(.success(.success(nil)))
          } else if response.code == 200 {
            promise(.success(.success(response.data)))
          } else {
            promise(.success(.failure(RepositoryError.serverError)))
          }
        } catch {
          // TODO: ERROR Handling
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
    /// Proeprty
    case matchStart(workoutTypeCode: Int)
    case matchCancel
    case isMatchedRandomPeer(workoutTypeCode: Int)

    /// TNEndPoint
    var path: String {
      switch self {
      case .matchStart:
        return "matches/start"
      case .matchCancel:
        return "matches/cancle"
      case .isMatchedRandomPeer:
        return "matches/random"
      }
    }

    var method: TNMethod {
      switch self {
      case .isMatchedRandomPeer,
           .matchStart:
        return .post
      case .matchCancel:
        return .get
      }
    }

    var query: Encodable? {
      return nil
    }

    var body: Encodable? {
      switch self {
      case let .matchStart(workoutTypeCode):
        return workoutTypeCode
      case let .isMatchedRandomPeer(workoutTypeCode):
        return workoutTypeCode
      case .matchCancel:
        return nil
      }
    }

    var headers: TNHeaders {
      return .init(headers: [.init(key: "Authorization", value: "accessToken")])
    }
  }
}
