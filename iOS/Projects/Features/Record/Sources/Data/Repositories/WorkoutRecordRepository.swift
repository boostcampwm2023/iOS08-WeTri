//
//  WorkoutRecordRepository.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/25/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Trinet
import Foundation


// MARK: - WorkoutSummaryRepository

public struct WorkoutRecordRepository: WorkoutRecordRepositoryRepresentable {

  private let provider: TNProvider<WorkoutRecordEndPoint>
  private let jsonDecoder: JSONDecoder = .init()

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  /// 운동을 기록합니다.
  /// - Parameter locationData: 사용자의 위치 정보
  /// - Parameter healthData: 사용자의 건강 정보
  /// - Returns: 기록 고유 Identifier
  func record(usingLocation locationData: [LocationDTO], andHealthData healthData: WorkoutHealth) -> AnyPublisher<Int, Error> {
    return Deferred {
      Future<Data, Error> { promise in
        Task {
          do {
            let data = try await provider.request(.init(locationList: locationData, health: healthData))
            promise(.success(data))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .decode(type: [String: Int].self, decoder: jsonDecoder)
    .compactMap(\.["recordId"])
    .eraseToAnyPublisher()
  }
}

// MARK: WorkoutSummaryRepository.WorkoutSummaryEndPoint

extension WorkoutRecordRepository {
  // TODO: 서버 값으로 세팅
  struct WorkoutRecordEndPoint: TNEndPoint {
    var path: String = "api/v1/records"

    var method: TNMethod = .post

    var query: Encodable? = nil

    var body: Encodable? = nil

    var headers: TNHeaders = .init(headers: [])

    init(locationList: [LocationDTO], health: WorkoutHealth) {
      // TODO: 요청 모델 설정 필요
    }
  }
}
