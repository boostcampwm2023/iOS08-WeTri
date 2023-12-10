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
  private let jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    return jsonDecoder
  }()

  private let recordDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy. MM. dd"
    return dateFormatter
  }()

  private let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    return formatter
  }()

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  /// 운동 요약 데이터를 가져옵니다.
  /// - Parameter id: 운동 데이터의 고유 Identifier 값
  func fetchWorkoutSummary(with id: Int) -> AnyPublisher<WorkoutSummaryModel, Error> {
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
    .map {
      let locations = $0.locations.components(separatedBy: ",").compactMap { location -> LocationModel? in
        let coordinates = location.components(separatedBy: "/")
        guard coordinates.count == 2,
              let latitude = Double(coordinates[0]),
              let longitude = Double(coordinates[1])
        else {
          return nil
        }
        return LocationModel(latitude: latitude, longitude: longitude)
      }
      return .init(
        id: $0.id,
        workoutTimeString: timeFormatter.string(from: TimeInterval($0.workoutTime)) ?? "-",
        distance: $0.distance,
        calorie: $0.calorie,
        averageHeartRate: $0.averageHeartRate,
        minimumHeartRate: $0.minimumHeartRate,
        maximumHeartRate: $0.maximumHeartRate,
        createTimeString: recordDateFormatter.string(from: $0.createdAt),
        mapScreenshots: $0.mapScreenshots,
        locations: locations
      )
    }
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
