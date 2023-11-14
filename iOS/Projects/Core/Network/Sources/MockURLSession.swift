//
//  MockURLSession.swift
//  Trinet
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - MockURLSession

public struct MockURLSession: URLSessionProtocol {
  let mockData: Data
  let mockResponse: URLResponse
  let mockError: Error?

  init(mockData: Data = Data(), mockResponse: URLResponse = URLResponse(), mockError: Error? = nil) {
    self.mockData = mockData
    self.mockResponse = mockResponse
    self.mockError = mockError
  }

  func data(for _: URLRequest, delegate _: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
    return (mockData, mockResponse)
  }

  func dataTask(
    with _: URLRequest,
    completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    return MockURLSessionData {
      completionHandler(mockData, mockResponse, mockError)
    }
  }
}

// MARK: - MockURLSessionData

final class MockURLSessionData: URLSessionDataTask {
  private let handler: () -> Void

  init(handler: @escaping () -> Void) {
    self.handler = handler
  }

  override func resume() {
    handler()
  }
}
