//
//  WorkoutRecordsRepository.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Cacher
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
  private let cacheManager = CacheManager.shared
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  func fetchRecordsList(date: Date) -> AnyPublisher<[Record], Error> {
    return Future<Data, Error> { promise in
      Task {
        do {
          let dateRequestDTO = try toDateRequestDTO(date: date)
          let key = makeKey(dateRequestDTO: dateRequestDTO)
          let data = try await provider.request(.dateOfRecords(dateRequestDTO))
          try cacheManager.set(cacheKey: key, data: data)
          return promise(.success(data))
        } catch {
          promise(.failure(error))
          Log.make().error("\(error)")
        }
      }
    }
    .decode(type: GWResponse<[RecordResponseDTO]>.self, decoder: decoder)
    .compactMap(\.data)
    .map { $0.compactMap(Record.init) }
    .catch { error -> AnyPublisher<[Record], Error> in
      Log.make().error("\(error)")
      return Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }

  // TODO: 오늘날짜 확인하는 로직은 Usecase에서 확인하고, 오늘날짜면 fetchRecordsList를 거치도록하고 아니면 fetchCacedRecords를 먼저 거치도록 해야한다. 그리고 fetchCaced를 통해 데이터를 받아왔다면 멈추고 받아오지 못했다면 fetchRecordsList를 실행
  func fetchCachedRecords(date: Date) -> AnyPublisher<[Record], Error> {
    return Future<Data, Error> { promise in
      do {
        let dateRequestDTO = try toDateRequestDTO(date: date)
        let key = makeKey(dateRequestDTO: dateRequestDTO)
        guard let data = try cacheManager.fetch(cacheKey: key) else {
          throw WorkoutRecordsRepositoryError.bindingError
        }
        return promise(.success(data))
      } catch {
        Log.make().error("\(error)")
      }
    }
    .decode(type: [Record].self, decoder: decoder)
    .eraseToAnyPublisher()
  }

  private func toDateRequestDTO(date: Date) throws -> DateRequestDTO {
    encoder.dateEncodingStrategy = .formatted(dateFormatter())
    let dateString = dateFormatter().string(from: date)
    guard let dateRequestDTO = transform(date: dateString) else {
      throw WorkoutRecordsRepositoryError.bindingError
    }
    return dateRequestDTO
  }

  private func makeKey(dateRequestDTO: DateRequestDTO) -> String {
    let year = dateRequestDTO.year
    let month = dateRequestDTO.month
    let day = dateRequestDTO.day
    return "\(year)-\(month)-\(day)"
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
