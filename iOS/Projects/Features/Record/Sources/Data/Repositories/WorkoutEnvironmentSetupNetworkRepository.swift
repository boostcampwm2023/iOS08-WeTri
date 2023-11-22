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

      guard
        let bundle = Bundle(identifier: PersistencyProperty.bundleIdentifier),
        let path = bundle.path(forResource: PersistencyProperty.workoutTypesFileName, ofType: PersistencyProperty.peerTypesFileNameOfType),
        let data = try? Data(contentsOf: URL(filePath: path))
      else {
        return promise(.failure(DataLayerError.noData))
      }
      let decoder = JSONDecoder()

      do {
        let workoutTypes = try decoder.decode([WorkoutTypeDTO].self, from: data)
        promise(.success(workoutTypes))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }

  func peerType() -> AnyPublisher<[PeerTypeDto], Error> {
    return Future<[PeerTypeDto], Error> { [weak self] promise in
      guard let self else {
        return promise(.failure(DataLayerError.repositoryDidDeinit))
      }

      guard
        let bundle = Bundle(identifier: PersistencyProperty.bundleIdentifier),
        let path = bundle.path(forResource: PersistencyProperty.peerTypesFileName, ofType: PersistencyProperty.peerTypesFileNameOfType),
        let data = try? Data(contentsOf: URL(filePath: path))
      else {
        return promise(.failure(DataLayerError.noData))
      }
      let decoder = JSONDecoder()

      do {
        let peerTypes = try decoder.decode([PeerTypeDto].self, from: data)
        promise(.success(peerTypes))
      } catch {
        promise(.failure(error))
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

  enum PersistencyProperty {
    static let bundleIdentifier = "kr.codesquad.boostcamp8.RecordFeature"
    static let peerTypesFileName = "PeerTypes"
    static let workoutTypesFileName = "WorkoutTypes"
    static let peerTypesFileNameOfType = "json"
  }
}