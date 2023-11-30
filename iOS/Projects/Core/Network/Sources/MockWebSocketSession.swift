//
//  MockWebSocketSession.swift
//  Trinet
//
//  Created by 홍승현 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - MockWebSocketTask

public final class MockWebSocketTask: WebSocketTaskProtocol {
  private var sentMessage: URLSessionWebSocketTask.Message?
  private var receiveContinuation: CheckedContinuation<URLSessionWebSocketTask.Message, Never>?

  public func send(_ message: URLSessionWebSocketTask.Message) async throws {
    sentMessage = message
    receiveContinuation?.resume(returning: message)
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

public struct MockWebSocketSession: URLSessionWebSocketProtocol {
  var webSocketTask: MockWebSocketTask = .init()

  public func webSocketTask(with _: URLRequest) -> WebSocketTaskProtocol {
    return webSocketTask
  }
}
