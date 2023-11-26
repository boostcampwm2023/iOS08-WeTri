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
  let provider: TNProvider<WorkoutPeerRandomMatchingRepositoryEndPoint>
  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }
}

// MARK: WorkoutPeerRandomMatchingRepositoryRepresentable

extension WorkoutPeerRandomMatchingRepository: WorkoutPeerRandomMatchingRepositoryRepresentable {
  func matcheStart(workoutSetting _: WorkoutSetting) -> AnyPublisher<Result<Void, Error>, Never> {
    return Future<Result<Void, Error>, Never> { promise in
      Task {
        do {
          let value = try await provider.request(.isMatchedRandomPeer)
          
        } catch {
          promise(.success(.failure(WorkoutRecordsRepositoryError.decodeError)))
        }
      }
    }.eraseToAnyPublisher()
  }

  func matchCancel() -> AnyPublisher<Result<Void, Error>, Never> {
    return Future<Result<Void, Error>, Never> { _ in
    }.eraseToAnyPublisher()
  }

  func isMatchedRandomPeer() -> AnyPublisher<Result<Void, Error>, Never> {
    return Future<Result<Void, Error>, Never> { _ in
    }.eraseToAnyPublisher()
  }
}

// MARK: WorkoutPeerRandomMatchingRepository.WorkoutPeerRandomMatchingRepositoryEndPoint

extension WorkoutPeerRandomMatchingRepository {
  enum WorkoutPeerRandomMatchingRepositoryEndPoint: TNEndPoint {
    /// Proeprty
    case matchStart(workout: String)
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
