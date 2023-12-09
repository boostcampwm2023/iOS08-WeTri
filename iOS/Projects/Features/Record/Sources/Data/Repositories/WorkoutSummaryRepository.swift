//
//  WorkoutSummaryRepository.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/22/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Trinet

// MARK: - WorkoutSummaryRepository

public struct WorkoutSummaryRepository: WorkoutSummaryRepositoryRepresentable {
  private let provider: TNProvider<WorkoutSummaryEndPoint>
  private let jsonDecoder: JSONDecoder = .init()

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  /// 운동 요약 데이터를 가져옵니다.
  /// - Parameter id: 운동 데이터의 고유 Identifier 값
  func fetchWorkoutSummary(with id: Int) -> AnyPublisher<WorkoutSummaryDTO, Error> {
    return Deferred {
      Future<Data, Error> { promise in
        Task {
          do {
            let data = try await provider.request(.init(recordID: id))
            promise(.success(data))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .decode(type: GWResponse<WorkoutSummaryDTO>.self, decoder: jsonDecoder)
    .compactMap(\.data)
    .eraseToAnyPublisher()
  }
}

// MARK: WorkoutSummaryRepository.WorkoutSummaryEndPoint

private extension WorkoutSummaryRepository {
  struct WorkoutSummaryEndPoint: TNEndPoint {
    let path: String

    let method: TNMethod = .get

    let query: Encodable? = nil

    let body: Encodable? = nil

    let headers: TNHeaders = .default

    init(recordID: Int) {
      path = "api/v1/records/\(recordID)"
    }
  }
}
