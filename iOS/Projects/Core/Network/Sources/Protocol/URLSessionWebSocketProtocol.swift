//
//  URLSessionWebSocketProtocol.swift
//  Trinet
//
//  Created by 홍승현 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - URLSessionWebSocketProtocol

public protocol URLSessionWebSocketProtocol {
  func webSocketTask(with request: URLRequest) -> WebSocketTaskProtocol
}

// MARK: - URLSession + URLSessionWebSocketProtocol

extension URLSession: URLSessionWebSocketProtocol {
  public func webSocketTask(with request: URLRequest) -> WebSocketTaskProtocol {
    let socketTask: URLSessionWebSocketTask = webSocketTask(with: request)
    return socketTask
  }
}
