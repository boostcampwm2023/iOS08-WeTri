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
  case bindingError
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
      let dateString = dateFormatter().string(from: date)
      guard let dateRequestDTO = transform(date: dateString) else {
        return promise(.failure(WorkoutRecordsRepositoryError.bindingError))
      }
      Task {
        let data = try await provider.request(.dateOfRecords(dateRequestDTO))
        return promise(.success(data))
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

  private func transform(date: String) -> DateRequestDTO? {
    let splited = date.split(separator: "-").map { String($0) }
    guard let year = Int(splited[0]),
          let month = Int(splited[1]),
          let day = Int(splited[2])
    else {
      return nil
    }
    return DateRequestDTO(year: year, month: month, day: day)
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
    case .bindingError:
      return "binding 실패"
    }
  }
}

// MARK: - WorkoutRecordsRepositoryEndPoint

enum WorkoutRecordsRepositoryEndPoint: TNEndPoint {
  case dateOfRecords(DateRequestDTO)

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
    case let .dateOfRecords(dateRequestDTO):
      return dateRequestDTO
    }
  }

  var headers: TNHeaders {
    // TODO:
    return TNHeaders(headers: [])
  }
}
