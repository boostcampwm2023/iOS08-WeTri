//
//  WorkoutPeerRandomMatchingRepository.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
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
            Log.make().fault("정상적으로 matcheStart data를 파싱했습니다.")
          } else {
            Log.make().fault("정상적으로 matcheStart data를 파싱하지 못했습니다.")
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
        Log.make().fault("정상적으로 matchCancel을 실행했습니다.")
      } catch {
        Log.make().fault("비정상적으로 matchCancel이 실행되었습니다.")
        // TODO: ERROR Handling
      }
    }
  }

  func isMatchedRandomPeer() -> AnyPublisher<Result<PeerMatchResponseDTO?, Error>, Never> {
    return Future<Result<PeerMatchResponseDTO?, Error>, Never> { promise in
      Task {
        do {
          let data = try await provider.request(.isMatchedRandomPeer)
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
    case isMatchedRandomPeer

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
      case .matchStart:
        return .post
      case .matchCancel:
        return .get
      case .isMatchedRandomPeer:
        return .get
      }
    }

    var query: Encodable? {
      return nil
    }

    var body: Encodable? {
      switch self {
      case let .matchStart(workout):
        return workout
      case .isMatchedRandomPeer,
           .matchCancel:
        return nil
      }
    }

    var headers: TNHeaders {
      return .init(headers: [.init(key: "Authorization", value: "accessToken")])
    }
  }
}
