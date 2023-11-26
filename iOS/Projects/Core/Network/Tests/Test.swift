//
//  Test.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 11/14/23.
//

@testable import Trinet
import XCTest

final class Test: XCTestCase {
  struct TestEndPoint: TNEndPoint {
    var baseURL: String = "base"
    var path: String = "path"
    var method: TNMethod = .get
    var query: Encodable? = nil
    var body: Encodable? = nil
    var headers: TNHeaders = .init(headers: [
      .init(key: "First", value: "First"),
    ])
  }

  var sut: TNEndPoint! = nil

  let provider = TNProvider<TestEndPoint>(session: URLSession.shared)

  func temp() async throws {}

  override func setUp() {
    sut = TestEndPoint()
  }

  override func tearDown() {
    sut = nil
  }

  func test_Base포함Path미포함_urlRequest를생성_URL확인() throws {
    sut = TestEndPoint(baseURL: "base", path: "")

    // Act
    let targetURL = try sut.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/"))
  }

  func test_Base와Path를포함_urlRequest를생성_성공() throws {
    // Act
    let targetURL = try sut.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/path"))
  }

  func test_Query() throws {
    sut = TestEndPoint(query: ["Some": "Time"])
    // Act
    let targetURL = try sut.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/path?Some=Time"))
  }

  func test_QueryIntValue() throws {
    sut = TestEndPoint(query: ["Int": "3"])
    // Act
    let targetURL = try sut.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/path?Int=3"))
  }

  func test_Body에String을넣고생성하고_request를생성했을때_body값이주입한String과똑같다() throws {
    let bodyString = "바디 스트링"
    sut = TestEndPoint(body: bodyString)

    let body = try sut.request().httpBody!

    XCTAssertEqual(bodyString, try JSONDecoder().decode(String.self, from: body))
  }

  func test_Body에nil을넣고_request를생성했을때_body의값이nil이적재된다() throws {
    sut = TestEndPoint(body: nil)

    let body = try sut.request().httpBody

    XCTAssertNil(body)
  }

  func test_HTTPHeader에값을넣고_request을생성하면_넣은Header값과똑같다() throws {
    let headers: TNHeaders = .init(headers: [
      .init(key: "Header", value: "1"),
      .init(key: "Headerable", value: "2"),
    ])

    sut = TestEndPoint(headers: headers)
    let requestHeader = try sut.request().allHTTPHeaderFields
    XCTAssertEqual(headers.dictionary, requestHeader)
  }

  func test_Mock확인() throws {
    let testData = "hihi".data(using: .utf8)!
    let mockSession = MockURLSession(mockData: testData)
    let provider = TNProvider<TestEndPoint>(session: mockSession)
    let targetSut = TestEndPoint()

    let expectation = XCTestExpectation(description: "API호출 완료 Expectaion")
    var providedData = Data()
    try provider.request(targetSut) { data, _, _ in
      providedData = data ?? Data()
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 3)

    XCTAssertEqual(testData, providedData)
  }

  func test_Mock확인2() async throws {
    let testData = "안녕하세요".data(using: .utf8)!
    let mockSession = MockURLSession(mockData: testData)
    let provider = TNProvider<TestEndPoint>(session: mockSession)
    let targetSut = TestEndPoint()
    let provideData = try await provider.request(targetSut)

    XCTAssertEqual(testData, provideData)
  }
}
