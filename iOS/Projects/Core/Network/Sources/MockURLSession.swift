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
  let mockDataByURLString: [String: Data]

  public init(
    mockData: Data = Data(),
    mockResponse: URLResponse = URLResponse(),
    mockError: Error? = nil,
    mockDataByURLString: [String: Data] = [:]
  ) {
    self.mockData = mockData
    self.mockResponse = mockResponse
    self.mockError = mockError
    self.mockDataByURLString = mockDataByURLString
  }

  public func data(for request: URLRequest, delegate _: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
    let urlString = request.url?.absoluteString ?? ""
    let mockData = mockDataByURLString[urlString] ?? mockData

    return (mockData, mockResponse)
  }

  public func dataTask(
    with request: URLRequest,
    completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    return MockURLSessionData {
      let urlString = request.url?.absoluteString ?? ""
      let mockData = mockDataByURLString[urlString] ?? mockData

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
