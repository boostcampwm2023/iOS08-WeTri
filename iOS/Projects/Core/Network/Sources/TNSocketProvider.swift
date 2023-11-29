//
//  TNSocketProvider.swift
//  Trinet
//
//  Created by 홍승현 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import OSLog

// MARK: - TNSocketProvidable

public protocol TNSocketProvidable {
  func send<Model: Codable>(model: Model) async throws
  func receive() async throws -> URLSessionWebSocketTask.Message?
}

// MARK: - TNSocketProvider

public struct TNSocketProvider<EndPoint: TNEndPoint>: TNSocketProvidable {
  private let session: URLSessionWebSocketProtocol
  private var task: WebSocketTaskProtocol?
  private let jsonEncoder: JSONEncoder = .init()

  public init(session: URLSessionWebSocketProtocol = URLSession.shared, endPoint: EndPoint) {
    self.session = session
    task = try? session.webSocketTask(with: endPoint.request())
    task?.resume()
  }

  public func send(model: some Codable) async throws {
    let frame = WebSocketFrame(data: model)
    try await task?.send(.data(jsonEncoder.encode(frame)))
  }

  public func receive() async throws -> URLSessionWebSocketTask.Message? {
    return try await task?.receive()
  }
}

// MARK: - WebSocketFrame

private struct WebSocketFrame<T: Codable>: Codable {
  let event: String
  let data: T

  init(event: String = "events", data: T) {
    self.event = event
    self.data = data
  }
}
