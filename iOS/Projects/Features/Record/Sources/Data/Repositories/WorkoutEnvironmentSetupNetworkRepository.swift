//
//  WorkoutEnvironmentSetupNetworkRepository.swift
//  WorkoutEnvironmentSetupNetworkRepository
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Trinet

// MARK: - WorkoutEnvironmentSetupNetworkRepository

final class WorkoutEnvironmentSetupNetworkRepository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable {
  let decoder = JSONDecoder()
  let repositorySession: URLSessionProtocol
  let provider: TNProvider<WorkoutEnvironmentSetupEndPoint>

  init(session: URLSessionProtocol) {
    repositorySession = session
    provider = .init(session: repositorySession)
  }

  func workoutTypes() -> AnyPublisher<[WorkoutTypeDTO], Error> {
    return Future<[WorkoutTypeDTO], Error> { [weak self] promise in
      guard let self else {
        return promise(.failure(DataLayerError.repositoryDidDeinit))
      }

      Task {
        do {
          let data = try await self.provider.request(.exerciseTypes)
          let workoutDTO = try self.decoder.decode(GWResponse<[WorkoutTypeDTO]>.self, from: data).data

          if let workoutDTO {
            promise(.success(workoutDTO))
          } else {
            promise(.failure(DataLayerError.noData))
          }

        } catch {
          promise(.failure(error))
        }
      }
    }.eraseToAnyPublisher()
  }

  func peerType() -> AnyPublisher<[PeerTypeDto], Error> {
    return Future<[PeerTypeDto], Error> { [weak self] promise in
      guard let self else {
        return promise(.failure(DataLayerError.repositoryDidDeinit))
      }

      Task {
        do {
          let data = try await self.provider.request(.peer)
          let peerDTO = try self.decoder.decode(GWResponse<[PeerTypeDto]>.self, from: data).data

          if let peerDTO {
            promise(.success(peerDTO))
          } else {
            promise(.failure(DataLayerError.noData))
          }
        } catch {
          promise(.failure(error))
        }
      }
    }.eraseToAnyPublisher()
  }
}

// MARK: WorkoutEnvironmentSetupNetworkRepository.WorkoutEnvironmentSetupEndPoint

extension WorkoutEnvironmentSetupNetworkRepository {
  enum WorkoutEnvironmentSetupEndPoint: TNEndPoint {
    case exerciseTypes
    case peer

    // TODO: API에 맞게 수정 예정
    var baseURL: String {
      switch self {
      case .exerciseTypes:
        return "https://www.naver.com"
      case .peer:
        return "https://www.naver.com"
      }
    }

    var path: String {
      switch self {
      case .exerciseTypes:
        return ""
      case .peer:
        return ""
      }
    }

    var method: Trinet.TNMethod { return .get }
    var query: Encodable? { nil }
    var body: Encodable? { nil }
    var headers: Trinet.TNHeaders { .init(headers: []) }
  }
}
