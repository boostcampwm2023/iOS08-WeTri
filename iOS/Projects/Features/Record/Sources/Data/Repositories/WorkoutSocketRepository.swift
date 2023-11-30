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

// MARK: - WorkoutSocketRepository

struct WorkoutSocketRepository {
  private let provider: TNSocketProvider<WorkoutSocketEndPoint>

  private var task: Task<Void, Error>?

  private let subject: PassthroughSubject<WorkoutRealTimeModel, Error> = .init()

  init(session: URLSessionWebSocketProtocol, roomID: String) {
    provider = .init(
      session: session,
      endPoint: .init(headers: [.init(key: "roomId", value: roomID)])
    )
    task = receiveParticipantsData()
  }

  private func receiveParticipantsData() -> Task<Void, Error> {
    return Task {
      Log.make(with: .network).debug("receive Ready")
      while let data = try await provider.receive() {
        switch data {
        case let .string(string):
          Log.make(with: .network).debug("received \(string)")
          subject.send(string)
        default:
          fatalError("절대 여기 와서는 안 됨")
        }
      }
      Log.make().fault("You can't enter this line")
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
