//
//  TNRequestAdaptor.swift
//  Trinet
//
//  Created by MaraMincho on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - TNRequestAdaptor

/// Request전에 특정 작업을 하고싶은 경우 사용합니다.
public protocol TNRequestAdaptor {
  func adapt(_ request: URLRequest, session: URLSessionProtocol) -> URLRequest?
}

// MARK: - TNRequestRetrier

public protocol TNRequestRetrier {
  func retry(
    _ request: URLRequest,
    session: URLSessionProtocol,
    successStatusCodeRange: Range<Int>,
    delegate: URLSessionDelegate?
  ) async throws -> Data
}

public typealias TNRequestInterceptor = TNRequestAdaptor & TNRequestRetrier
