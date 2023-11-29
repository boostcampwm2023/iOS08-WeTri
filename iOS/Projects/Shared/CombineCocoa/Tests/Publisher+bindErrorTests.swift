//
//  Publisher+bindErrorTests.swift
//  CombineCocoaTests
//
//  Created by 홍승현 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

@testable import CombineCocoa

import Combine
import XCTest

final class PublisherBindErrorTests: XCTestCase {
  enum TestError: Error {
    case example
  }

  private var subscriptions: Set<AnyCancellable> = []

  override func tearDown() {
    subscriptions.removeAll()
  }

  func testBindToPassthroughSubjectWithError() {
    // arrange
    let expectation = XCTestExpectation(description: "PassthroughSubject should receive error")
    let passthroughSubject = PassthroughSubject<String, TestError>()
    let publisher = Fail<String, TestError>(error: .example)

    // act & assert
    passthroughSubject
      .sink { completion in
        if case let .failure(error) = completion, case .example = error {
          expectation.fulfill()
        }
      } receiveValue: { _ in }
      .store(in: &subscriptions)

    publisher
      .bind(to: passthroughSubject)
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1.0)
  }

  func testBindToCurrentValueSubjectWithError() {
    // arrange
    let expectation = XCTestExpectation(description: "CurrentValueSubject should receive error")
    let currentValueSubject = CurrentValueSubject<String, TestError>("Initial Value")
    let publisher = Fail<String, TestError>(error: .example)

    // act & assert
    currentValueSubject
      .sink { completion in
        if case let .failure(error) = completion, case .example = error {
          expectation.fulfill()
        }
      } receiveValue: { _ in }
      .store(in: &subscriptions)

    publisher
      .bind(to: currentValueSubject)
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1.0)
  }
}
