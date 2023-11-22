//
//  MockWorkoutRecordsRepository.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/22.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Trinet

// MARK: - MockWorkoutRecordsRepository

final class MockWorkoutRecordsRepository: WorkoutRecordsRepository {
  func fetchRecordsList(ymd: String) -> AnyPublisher<[Record], Error> {
    return Future<[Record], Error> { promise in
      let records: [Record] = [
        Record(mode: .run, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
      ]

      let testData = (try? JSONEncoder().encode(records))!
      let mockURLSession = MockURLSession(mockData: testData)
      let provider = TNProvider<WorkoutRecordTestEndPoint>(session: mockURLSession)
      let endpoint = WorkoutRecordTestEndPoint(
        path: "Pathpahtpath",
        method: .post,
        body: ymd
      )

      Task {
        guard let data = try? await provider.request(WorkoutRecordTestEndPoint()) else {
          return promise(.failure(WorkoutRecordsRepositoryError.requestError))
        }
        guard let records = try? JSONDecoder().decode([Record].self, from: data) else {
          return promise(.failure(WorkoutRecordsRepositoryError.decodeError))
        }
        return promise(.success(records))
      }
    }
    .catch { error -> AnyPublisher<[Record], Error> in
      if let workoutRecordsError = error as? WorkoutRecordsRepositoryError {
        // TODO: Log로직 추가
      }
      return Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - WorkoutRecordsRepositoryError

enum WorkoutRecordsRepositoryError: Error {
  case requestError
  case decodeError
}

// MARK: LocalizedError

extension WorkoutRecordsRepositoryError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .requestError:
      return "Network-Request 실패"
    case .decodeError:
      return "decode 실패"
    }
  }
}
