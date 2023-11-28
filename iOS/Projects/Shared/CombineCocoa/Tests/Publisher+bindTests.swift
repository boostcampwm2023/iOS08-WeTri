//
//  Publisher+bindTests.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍승현 on 11/23/23.
//

@testable import CombineCocoa

import Combine
import XCTest

final class PublisherBindTests: XCTestCase {
  private var subscriptions: Set<AnyCancellable> = []
  private let publisher: PassthroughSubject<Void, Never> = .init()
  private var sut: AnyPublisher<Void, Never>?

  override func tearDown() {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()
  }

  func testBindToPassthroughSubject() {
    // assign
    let expectation = XCTestExpectation(description: "PassthroughSubject should receive value")
    let passthroughSubject = PassthroughSubject<String, Never>()
    let testValue = "Test"

    // act & assert

    passthroughSubject
      .sink { receivedValue in
        XCTAssertEqual(receivedValue, testValue)
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    Just(testValue)
      .bind(to: passthroughSubject)
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1.0)
  }

  func testBindToCurrentValueSubject() {
    // assign
    let expectation = XCTestExpectation(description: "CurrentValueSubject should receive value")
    let currentValueSubject = CurrentValueSubject<String, Never>("Initial Value")
    let testValue = "Test"

    // act
    Just(testValue)
      .bind(to: currentValueSubject)
      .store(in: &subscriptions)

    // assert
    currentValueSubject
      .sink { receivedValue in
        XCTAssertEqual(receivedValue, testValue)
        expectation.fulfill()
      }
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1.0)
  }
}
