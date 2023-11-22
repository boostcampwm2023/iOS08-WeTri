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

struct WorkoutEnvironmentSetupNetworkRepository: WorkoutEnvironmentSetupNetworkRepositoryRepresentable {
  let decoder = JSONDecoder()
  let provider: TNProvider<WorkoutEnvironmentSetupEndPoint>

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  func workoutTypes() -> AnyPublisher<[WorkoutTypeDTO], Error> {
    return Future<[WorkoutTypeDTO], Error> { promise in

      guard
        let bundle = Bundle(identifier: PersistencyProperty.bundleIdentifier),
        let path = bundle.path(forResource: PersistencyProperty.workoutTypesFileName, ofType: PersistencyProperty.peerTypesFileNameOfType),
        let data = try? Data(contentsOf: URL(filePath: path))
      else {
        return promise(.failure(DataLayerError.noData))
      }

      do {
        let workoutTypes = try decoder.decode(GWResponse<[WorkoutTypeDTO]>.self, from: data).data
        guard let workoutTypes else {
          promise(.failure(DataLayerError.curreptedData))
          return
        }

        promise(.success(workoutTypes))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }

  func peerType() -> AnyPublisher<[PeerTypeDTO], Error> {
    return Future<[PeerTypeDTO], Error> { promise in

      guard
        let bundle = Bundle(identifier: PersistencyProperty.bundleIdentifier),
        let path = bundle.path(forResource: PersistencyProperty.peerTypesFileName, ofType: PersistencyProperty.peerTypesFileNameOfType),
        let data = try? Data(contentsOf: URL(filePath: path))
      else {
        return promise(.failure(DataLayerError.noData))
      }

      do {
        let peerTypes = try decoder.decode(GWResponse<[PeerTypeDTO]>.self, from: data).data
        guard let peerTypes else {
          promise(.failure(DataLayerError.curreptedData))
          return
        }

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

    var method: TNMethod { return .get }
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
