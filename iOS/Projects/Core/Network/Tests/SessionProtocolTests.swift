//
//  SessionProtocolTests.swift
//  TrinetTests
//
//  Created by 홍승현 on 11/27/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

@testable import Trinet
import XCTest

final class SessionProtocolTests: XCTestCase {
  /// 404 에러를 잘 가져오는 지 테스트합니다.
  func testErrorResponseHandling() async throws {
    let response = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
    let mockSession = MockURLSession(mockResponse: response)
    let provider = TNProvider<MockEndPoint>(session: mockSession)
    let sut = MockEndPoint()

    do {
      _ = try await provider.request(sut)
      XCTFail("Expected an error but did not receive one.")
    } catch TNError.clientError {
      // 성공: 올바른 에러 타입임
    } catch {
      XCTFail("Received an unexpected error type: \(error).")
    }
  }

  /// 네트워크 요청 실패를 잘 파악하는지 확인합니다.
  func testRequestTimeout() async throws {
    let timeoutError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
    let mockSession = MockURLSession(mockError: timeoutError)
    let provider = TNProvider<MockEndPoint>(session: mockSession)
    let sut = MockEndPoint()

    do {
      _ = try await provider.request(sut)
      XCTFail("Expected a timeout error but did not receive one.")
    } catch {
      // 예상한 대로 타임아웃 에러가 발생하면 테스트는 성공
    }
  }

  /// 성공적으로 데이터를 가져왔는지 파악합니다.
  func testSuccessfulDataRequest() async throws {
    let testData = "안녕하세요".data(using: .utf8)!
    let mockSession = MockURLSession(mockData: testData)
    let provider = TNProvider<MockEndPoint>(session: mockSession)
    let sut = MockEndPoint()

    do {
      let data = try await provider.request(sut)
      XCTAssertEqual(data, testData, "The data returned from the provider did not match the expected data.")
    } catch {
      XCTFail("Did not expect an error but received: \(error).")
    }
  }

  /// Completion을 이용해서 성공적으로 데이터를 가져왔는지 파악합니다.
  func testSuccessfulDataRequestUsingCompletion() throws {
    let testData = "hihi".data(using: .utf8)!
    let mockSession = MockURLSession(mockData: testData)
    let provider = TNProvider<MockEndPoint>(session: mockSession)
    let sut = MockEndPoint()

    let expectation = XCTestExpectation(description: "Completion handler called")
    try provider.request(sut) { data, response, error in
      XCTAssertEqual(testData, data, "The data returned from the provider did not match the expected data.")
      XCTAssertNotNil(response)
      XCTAssertNil(error)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 3)
  }
}
