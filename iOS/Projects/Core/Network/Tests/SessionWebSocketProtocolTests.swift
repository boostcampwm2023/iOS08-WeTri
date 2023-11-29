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
  private var mockSession: MockWebSocketSession?
  private var socketProvider: TNSocketProvider<MockEndPoint>?

  struct TestModel: Codable, Equatable {
    var id: UUID = .init()
    var profileImage: String = "https://hello.world"
    var nickname: String = "NickName"
    var message: String = ""
  }

  override func setUp() {
    super.setUp()
    let mockSession = MockWebSocketSession()
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

    // Receive 메서드를 비동기로 호출하여 결과 검증
    let receivedMessage = try await socketProvider?.receive()
    guard case let .data(data) = receivedMessage else {
      XCTFail("Received message is not of type .data")
      return
    }

    let receivedModel = try JSONDecoder().decode(WebSocketFrame<TestModel>.self, from: data)
    XCTAssertEqual(receivedModel.data, testModel, "Received model does not match sent model")
  }
}
