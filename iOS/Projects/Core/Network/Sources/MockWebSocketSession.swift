//
//  MockWebSocketSession.swift
//  Trinet
//
//  Created by 홍승현 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - MockWebSocketTask

public final class MockWebSocketTask<DataModel: Codable>: WebSocketTaskProtocol {
  private var sentMessage: URLSessionWebSocketTask.Message?
  private var receiveContinuation: CheckedContinuation<URLSessionWebSocketTask.Message, Never>?
  private let jsonEncoder: JSONEncoder = .init()
  private let jsonDecoder: JSONDecoder = .init()

  public init() {}

  public func send(_ message: URLSessionWebSocketTask.Message) async throws {
    switch message {
    case let .data(data):
      let socketFrame = try jsonDecoder.decode(WebSocketFrame<DataModel>.self, from: data)
      let jsonData = try jsonEncoder.encode(socketFrame.data)
      guard let jsonString = String(data: jsonData, encoding: .utf8) else {
        throw MockWebSocketError.stringConversionFailed
      }

      let stringMessage = URLSessionWebSocketTask.Message.string(jsonString)
      sentMessage = stringMessage
      receiveContinuation?.resume(returning: stringMessage)
    default:
      sentMessage = message
      receiveContinuation?.resume(returning: message)
    }
  }

  public func receive() async throws -> URLSessionWebSocketTask.Message {
    if let receivedMessage = sentMessage {
      sentMessage = nil
      return receivedMessage
    }

    return await withCheckedContinuation { continuation in
      receiveContinuation = continuation
    }
  }

  public func resume() {}
}

// MARK: - MockWebSocketSession

public struct MockWebSocketSession<DataModel: Codable>: URLSessionWebSocketProtocol {
  var webSocketTask: MockWebSocketTask<DataModel> = .init()

  public init() {}

  public func webSocketTask(with _: URLRequest) -> WebSocketTaskProtocol {
    return webSocketTask
  }
}

// MARK: - MockWebSocketError

private enum MockWebSocketError: Error {
  case stringConversionFailed
}
