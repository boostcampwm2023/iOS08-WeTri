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

final class MockWorkoutRecordsRepository: WorkoutRecordsRepository {
  func fetchRecordsList(ymd: String) -> AnyPublisher<[Record], Error> {
    return Future<[Record], Error> { promise in
      let records: [Record] = [
        //                Record(mode: .run, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
//        Record(mode: .swim, timeToTime: "08:00~09:00", distance: 12.12),
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
        guard let data = try? await provider.request(WorkoutRecordTestEndPoint()),
              let records = try? JSONDecoder().decode([Record].self, from: data)
        else {
          return
        }
        promise(.success(records))
      }
    }
    .eraseToAnyPublisher()
  }
}
