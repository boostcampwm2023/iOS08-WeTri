//
//  InterceptorTest.swift
//  TrinetTests
//
//  Created by MaraMincho on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//
@testable import Trinet
import XCTest

final class InterceptorTest: XCTestCase {
  var mockSession: MockURLSession! = nil
  var provider: TNProvider<MockEndPoint>! = nil
  let mockEndPoint = MockEndPoint()
  let interceptor = TestInterceptor()

  struct TestInterceptor: TNRequestInterceptor {
    func adapt(_ request: URLRequest, session _: URLSessionProtocol) -> URLRequest {
      var urlrequest = request
      urlrequest.url = URL(string: "adapt")
      return urlrequest
    }

    func retry(_ request: URLRequest, session _: URLSessionProtocol, data: Data, response: URLResponse, delegate _: URLSessionDelegate?) async throws -> (Data, URLResponse) {
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        throw TNError.unknownError
      }
      if statusCode == 401 {
        let retryData = "retry".data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (retryData, response)
      }
      return (data, response)
    }
  }

  override func setUpWithError() throws {
    mockSession = .init()
    provider = .init(session: mockSession)
  }

  override func tearDownWithError() throws {
    mockSession = nil
    provider = nil
  }

  func test_request가_adapt를했을때() async throws {
    // arrange
    let tokkenDidBeExpierResponse = HTTPURLResponse(url: URL(string: "www.naver.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
    mockSession = MockURLSession(mockData: "나는목이다".data(using: .utf8)!, mockResponse: tokkenDidBeExpierResponse)
    provider = .init(session: mockSession)

    // act
    let data = try await provider.request(mockEndPoint, interceptor: interceptor)

    // assert
    let stringData = String(data: data, encoding: .utf8)
    XCTAssertEqual(stringData, "retry")
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
}
