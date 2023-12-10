//
//  WorkoutRecordsRepository.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Cacher
import Combine
import CommonNetworkingKeyManager
import Foundation
import Log
import Trinet

// MARK: - WorkoutRecordsRepositoryError

enum WorkoutRecordsRepositoryError: Error {
  case requestError
  case decodeError
  case bindingError
  case invalidCachedData
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

  func fetchRecordsList(date: Date, isToday: Bool) -> AnyPublisher<[Record], Error> {
    return Future<Data, Error> { promise in
      Task {
        do {
          let dateRequestDTO = try toDateRequestDTO(date: date)
          let key = makeKey(dateRequestDTO: dateRequestDTO)
          let data = try await provider.request(.dateOfRecords(dateRequestDTO), interceptor: TNKeychainInterceptor.shared)
          if !isToday {
            try cacheManager.set(cacheKey: key, data: data)
          }
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
        return promise(.failure(WorkoutRecordsRepositoryError.invalidCachedData))
      }
    }
    .decode(type: GWResponse<[RecordResponseDTO]>.self, decoder: decoder)
    .compactMap(\.data)
    .map { $0.compactMap(Record.init) }
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
    case .invalidCachedData:
      return "cache에 데이터가 존재하지 않습니다."
    }
  }
}

// MARK: - WorkoutRecordsRepositoryEndPoint

enum WorkoutRecordsRepositoryEndPoint: TNEndPoint {
  case dateOfRecords(DateRequestDTO)

  var path: String {
    switch self {
    case .dateOfRecords:
      return "/api/v1/records/me"
    }
  }

  var method: TNMethod {
    switch self {
    case .dateOfRecords:
      return .get
    }
  }

  var query: Encodable? {
    switch self {
    case let .dateOfRecords(dateRequestDTO):
      return ["year": dateRequestDTO.year, "month": dateRequestDTO.month, "day": dateRequestDTO.day]
    }
  }

  var body: Encodable? {
    return nil
  }

  var headers: TNHeaders {
    return .default
  }
}
