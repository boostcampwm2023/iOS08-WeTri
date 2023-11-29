//
//  WebSocketTaskProtocol.swift
//  Trinet
//
//  Created by 홍승현 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - WebSocketTaskProtocol

public protocol WebSocketTaskProtocol {
  func send(_ message: URLSessionWebSocketTask.Message) async throws

  func receive() async throws -> URLSessionWebSocketTask.Message

  func resume()
}

// MARK: - URLSessionWebSocketTask + WebSocketTaskProtocol

extension URLSessionWebSocketTask: WebSocketTaskProtocol {}
