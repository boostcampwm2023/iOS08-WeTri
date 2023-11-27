//
//  Publisher+WithLatestFromTests.swift
//  CombineCocoaTests
//
//  Created by 홍승현 on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

@testable import CombineCocoa

import Combine
import XCTest

final class PublisherWithLatestFromTests: XCTestCase {
  private var subscriptions: Set<AnyCancellable> = []

  private enum TestError: Error {
    case test
  }

  override func tearDown() {
    subscriptions.removeAll()
  }

  func testWithLatestFrom_CombinesValuesCorrectly() {
    // assign
    let expectation = XCTestExpectation(description: "Received combined value")
    let upstreamSubject = PassthroughSubject<Int, Never>()
    let otherSubject = PassthroughSubject<String, Never>()

    // act
    upstreamSubject
      .withLatestFrom(otherSubject) { number, string in "\(number)-\(string)" }
      .sink { combinedValue in
        XCTAssertEqual(combinedValue, "1-A")
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    otherSubject.send("A")
    upstreamSubject.send(1)

    // assert
    wait(for: [expectation], timeout: 1.0)
  }

  func testWithLatestFrom_NoEmissionWithoutSecondaryEmission() {
    // assign
    let upstreamSubject = PassthroughSubject<Int, Never>()
    let otherSubject = PassthroughSubject<String, Never>()
    var receivedValues = [String]()

    // act
    upstreamSubject
      .withLatestFrom(otherSubject) { "\($0)-\($1)" }
      .sink { receivedValues.append($0) }
      .store(in: &subscriptions)

    upstreamSubject.send(1)

    // assert
    XCTAssertTrue(receivedValues.isEmpty, "Should not emit values without both publishers emitting")
  }

  func testWithLatestFrom_UsesLatestValueFromSecondary() {
    // assign
    let upstreamSubject = PassthroughSubject<Int, Never>()
    let otherSubject = PassthroughSubject<String, Never>()
    var latestReceivedValue = ""

    // act
    upstreamSubject
      .withLatestFrom(otherSubject) { "\($0)-\($1)" }
      .sink { latestReceivedValue = $0 }
      .store(in: &subscriptions)

    otherSubject.send("A")
    otherSubject.send("B") // 현재 제일 최신 값
    upstreamSubject.send(1)

    // assert
    XCTAssertEqual(latestReceivedValue, "1-B", "Should use the latest value from the secondary publisher")
  }

  func testWithLatestFrom_CompletesWhenPrimaryCompletes() {
    // assign
    let upstreamSubject = PassthroughSubject<Int, Never>()
    let otherSubject = PassthroughSubject<String, Never>()
    let expectation = XCTestExpectation(description: "Completion")

    // act
    upstreamSubject
      .withLatestFrom(otherSubject) { "\($0)-\($1)" }
      .sink { _ in
        expectation.fulfill()
      } receiveValue: { _ in
      }
      .store(in: &subscriptions)

    upstreamSubject.send(completion: .finished)

    // assert
    wait(for: [expectation], timeout: 1.0)
  }

  func testWithLatestFrom_PropagatesErrors() {
    // assign
    let upstreamSubject = PassthroughSubject<Int, TestError>()
    let otherSubject = PassthroughSubject<String, TestError>()
    let expectation = XCTestExpectation(description: "Error received")

    // act
    upstreamSubject
      .withLatestFrom(otherSubject) { "\($0)-\($1)" }
      .sink {
        if case .failure = $0 {
          expectation.fulfill()
        }
      } receiveValue: { _ in
      }
      .store(in: &subscriptions)

    upstreamSubject.send(completion: .failure(TestError.test))

    // assert
    wait(for: [expectation], timeout: 1.0)
  }

  func testWithLatestFrom_SecondaryLatestValueUsed() {
    // assign
    let upstreamSubject = PassthroughSubject<Int, Never>()
    let otherSubject = PassthroughSubject<String, Never>()
    var latestReceivedValue = ""

    // act
    upstreamSubject
      .withLatestFrom(otherSubject)
      .sink { latestReceivedValue = $0 }
      .store(in: &subscriptions)

    otherSubject.send("A")
    otherSubject.send("B") // 최신 값
    upstreamSubject.send(1)

    // assert
    XCTAssertEqual(latestReceivedValue, "B", "Should use the latest value from the secondary publisher when the primary publisher emits")
  }
}
