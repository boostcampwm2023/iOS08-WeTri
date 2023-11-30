//
//  WorkoutRecordsRepository.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log
import Trinet

// MARK: - WorkoutRecordsRepositoryError

enum WorkoutRecordsRepositoryError: Error {
  case requestError
  case decodeError
}

// MARK: - WorkoutRecordsRepository

struct WorkoutRecordsRepository: WorkoutRecordsRepositoryRepresentable {
  private let provider: TNProvider<WorkoutRecordsRepositoryEndPoint>
  private let encoder = JSONEncoder()

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  func fetchRecordsList(date: Date) -> AnyPublisher<[Record], Error> {
    return Future<Data, Error> { promise in
      encoder.dateEncodingStrategy = .formatted(dateFormatter())
      do {
        let requestBody = try encoder.encode(date)
        Task {
          let data = try await provider.request(.dateOfRecords(requestBody))
          return promise(.success(data))
        }
      } catch {
        Log.make().error("\(error)")
      }
    }
    .decode(type: [Record].self, decoder: JSONDecoder())
    .catch { error -> AnyPublisher<[Record], Error> in
      Log.make().error("\(error)")
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

// MARK: - WorkoutRecordsRepositoryError + LocalizedError

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

// MARK: - WorkoutRecordsRepositoryEndPoint

enum WorkoutRecordsRepositoryEndPoint: TNEndPoint {
  case dateOfRecords(Data)

  var path: String {
    switch self {
    case .dateOfRecords:
      return "records/me"
    }
  }

  var method: TNMethod {
    switch self {
    case .dateOfRecords:
      return .post
    }
  }

  var query: Encodable? {
    return nil
  }

  var body: Encodable? {
    switch self {
    case let .dateOfRecords(data):
      return data
    }
  }

  var headers: TNHeaders {
    // TODO:
    return TNHeaders(headers: [])
  }
}
