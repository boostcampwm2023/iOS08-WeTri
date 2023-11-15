//
//  URLSessionProtocol.swift
//  Trinet
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - URLSessionProtocol

public protocol URLSessionProtocol {
  func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)

  func dataTask(
    with request: URLRequest,
    completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask
}

// MARK: - URLSession + URLSessionProtocol

extension URLSession: URLSessionProtocol {}
