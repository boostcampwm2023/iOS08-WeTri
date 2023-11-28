//
//  EndPointTests.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 11/14/23.
//

@testable import Trinet
import XCTest

final class EndPointTests: XCTestCase {
  private var sut: TNEndPoint?

  override func setUp() {
    sut = MockEndPoint()
  }

  override func tearDown() {
    sut = nil
  }

  func test_Base포함Path미포함_urlRequest를생성_URL확인() throws {
    sut = MockEndPoint(baseURL: "base", path: "")

    // Act
    let targetURL = try sut?.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/"))
  }

  func test_Base와Path를포함_urlRequest를생성_성공() throws {
    // Act
    let targetURL = try sut?.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/path"))
  }

  func test_Query() throws {
    sut = MockEndPoint(query: ["Some": "Time"])
    // Act
    let targetURL = try sut?.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/path?Some=Time"))
  }

  func test_QueryIntValue() throws {
    sut = MockEndPoint(query: ["Int": "3"])
    // Act
    let targetURL = try sut?.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/path?Int=3"))
  }

  func test_Body에String을넣고생성하고_request를생성했을때_body값이주입한String과똑같다() throws {
    let bodyString = "바디 스트링"
    sut = MockEndPoint(body: bodyString)

    let body = try sut!.request().httpBody!

    XCTAssertEqual(bodyString, try JSONDecoder().decode(String.self, from: body))
  }

  func test_Body에nil을넣고_request를생성했을때_body의값이nil이적재된다() throws {
    sut = MockEndPoint(body: nil)

    let body = try sut?.request().httpBody

    XCTAssertNil(body)
  }

  func test_HTTPHeader에값을넣고_request을생성하면_넣은Header값과똑같다() throws {
    let headers: TNHeaders = [
      "Header": "1",
      "Headerable": "2",
    ]

    sut = MockEndPoint(headers: headers)
    let requestHeader = try sut?.request().allHTTPHeaderFields
    XCTAssertEqual(headers.dictionary, requestHeader)
  }
}
