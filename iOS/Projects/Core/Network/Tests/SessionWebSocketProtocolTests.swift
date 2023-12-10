//
//  SessionWebSocketProtocolTests.swift
//  TrinetTests
//
//  Created by 홍승현 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

@testable import Trinet

import XCTest

final class SessionWebSocketProtocolTests: XCTestCase {
  private var mockSession: MockWebSocketSession<TestModel>?
  private var socketProvider: TNSocketProvider<MockEndPoint>?

  struct TestModel: Codable, Equatable {
    var id: UUID = .init()
    var profileImage: String = "https://hello.world"
    var nickname: String = "NickName"
    var message: String = ""
  }

  override func setUp() {
    super.setUp()
    let mockSession = MockWebSocketSession<TestModel>()
    self.mockSession = mockSession
    socketProvider = TNSocketProvider(session: mockSession, endPoint: MockEndPoint())
  }

  override func tearDown() {
    mockSession = nil
    socketProvider = nil
    super.tearDown()
  }

  func testSendAndReceive() async throws {
    // arrange
    let testModel = TestModel()

    // act
    Task {
      try await self.socketProvider?.send(model: testModel)
    }

    // assert

    // Receive 메서드를 비동기로 호출하여 결과 검증
    let receivedMessage = try await socketProvider?.receive()
    guard case let .string(string) = receivedMessage else {
      XCTFail("Received message is not of type .string")
      return
    }

    guard let jsonData = string.data(using: .utf8) else {
      XCTFail("data cannot parse to data")
      return
    }

    let receivedModel = try JSONDecoder().decode(WebSocketFrame<TestModel>.self, from: jsonData)
    XCTAssertEqual(receivedModel.data, testModel, "Received model does not match sent model")
  }
}
