//
//  WorkoutSocketRepository.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log
import Trinet

// MARK: - WorkoutSocketRepositoryDependency

protocol WorkoutSocketRepositoryDependency {
  var roomID: String { get }
}

// MARK: - WorkoutSocketRepository

struct WorkoutSocketRepository {
  private let provider: TNSocketProvider<WorkoutSocketEndPoint>

  private let jsonDecoder: JSONDecoder = .init()
  private var task: Task<Void, Error>?

  private let subject: PassthroughSubject<WorkoutRealTimeModel, Error> = .init()

  init(session: URLSessionWebSocketProtocol, dependency: WorkoutSocketRepositoryDependency) {
    provider = .init(
      session: session,
      endPoint: .init(headers: [.init(key: "roomId", value: dependency.roomID)])
    )
    task = receiveParticipantsData()
  }

  private func stringToWorkoutRealTimeModel(rawString: String) throws -> WorkoutRealTimeModel {
    guard let jsonData = rawString.data(using: .utf8) else {
      throw WorkoutSocketRepositoryError.invalidStringForConversion
    }
    return try jsonDecoder.decode(WorkoutRealTimeModel.self, from: jsonData)
  }

  private func receiveParticipantsData() -> Task<Void, Error> {
    return Task {
      Log.make(with: .network).debug("소켓: receive Ready")
      while true {
        do {
          switch try await provider.receive() {
          case let .string(string):
            Log.make(with: .network).debug("received \(string)")
            try subject.send(stringToWorkoutRealTimeModel(rawString: string))
          default:
            Log.make().error("소켓: You can't enter this line")
          }
        } catch {
          subject.send(completion: .failure(error))
        }
      }
      Log.make().fault("소켓: You can't enter this line")
    }
  }
}

// MARK: WorkoutSocketRepositoryRepresentable

extension WorkoutSocketRepository: WorkoutSocketRepositoryRepresentable {
  func fetchParticipantsRealTime() -> AnyPublisher<WorkoutRealTimeModel, Error> {
    subject.eraseToAnyPublisher()
  }

  func sendMyWorkout(with model: WorkoutRealTimeModel) -> AnyPublisher<Void, Error> {
    Future { promise in
      Task {
        do {
          try await provider.send(model: model)
          promise(.success(()))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: WorkoutSocketRepository.WorkoutSocketRepositoryError

extension WorkoutSocketRepository {
  enum WorkoutSocketRepositoryError: LocalizedError {
    case invalidStringForConversion

    var errorDescription: String? {
      return "문자열을 Data로 변환할 수 없습니다. 문자열이 비어있는지 확인하세요."
    }
  }
}

// MARK: - WorkoutSocketEndPoint

private struct WorkoutSocketEndPoint: TNEndPoint {
  let baseURL: String = Bundle.main.infoDictionary?["SocketURL"] as? String ?? ""

  let path: String = ""

  let method: TNMethod = .get

  let query: Encodable? = nil

  let body: Encodable? = nil

  let headers: TNHeaders

  init(headers: TNHeaders) {
    self.headers = headers
  }
}
