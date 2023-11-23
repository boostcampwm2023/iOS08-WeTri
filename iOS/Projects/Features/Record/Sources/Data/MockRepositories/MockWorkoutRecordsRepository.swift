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

final class MockWorkoutRecordsRepository: WorkoutRecordsRepositoryRepresentable {
  func fetchRecordsList(date: Date) -> AnyPublisher<[Record], Error> {
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

      let encoder = JSONEncoder()
      let testData = (try? encoder.encode(records))!
      encoder.dateEncodingStrategy = .formatted(self.dateFormatter())
      let requestBody = (try? encoder.encode(date))!
      let mockURLSession = MockURLSession(mockData: testData)
      let provider = TNProvider<WorkoutRecordTestEndPoint>(session: mockURLSession)
      let endpoint = WorkoutRecordTestEndPoint(
        path: "Pathpahtpath",
        method: .post,
        body: requestBody
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

  private func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
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
