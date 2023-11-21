//
//  WorkoutEnvironmentSetupNetworkRepository.swift
//  WorkoutEnvironmentSetupNetworkRepository
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

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

  func fetchWorkoutTypes() {}

  func workoutTypes() async throws -> [WorkoutTypeDTO] {
    let data = try await provider.request(.exerciseTypes)

    guard let workoutDTO = try decoder.decode(GWResponse<[WorkoutTypeDTO]>.self, from: data).data
    else {
      throw DataLayerError.noData
    }

    return workoutDTO
  }

  func peerType() async throws -> [PeerTypeDto] {
    let data = try await provider.request(.peer)

    guard let pearTypesDTO = try decoder.decode(GWResponse<[PeerTypeDto]>.self, from: data).data
    else {
      throw DataLayerError.noData
    }

    return pearTypesDTO
  }
}

// MARK: WorkoutEnvironmentSetupNetworkRepository.WorkoutEnvironmentSetupEndPoint

extension WorkoutEnvironmentSetupNetworkRepository {
  enum WorkoutEnvironmentSetupEndPoint: TNEndPoint {
    case exerciseTypes
    case peer

    var baseURL: String {
      switch self {
      case .exerciseTypes:
        return ""
      case .peer:
        return ""
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
