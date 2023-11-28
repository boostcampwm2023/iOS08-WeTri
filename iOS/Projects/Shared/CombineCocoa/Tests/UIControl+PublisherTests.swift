//
//  UIControl+PublisherTests.swift
//  CombineCocoaTests
//
//  Created by 홍승현 on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

@testable import CombineCocoa

import Combine
import UIKit
import XCTest

final class UIControlPublisherTests: XCTestCase {
  private var subscriptions: Set<AnyCancellable> = []

  override func tearDown() {
    subscriptions.removeAll()
  }

  func testEventFiring() {
    let control = UIControl()
    let event: UIControl.Event = .touchUpInside
    var eventFired = false

    control.publisher(event)
      .sink { _ in
        eventFired = true
      }
      .store(in: &subscriptions)

    control.sendActions(for: event)

    XCTAssertTrue(eventFired, "Event should be fired and received by the publisher")
  }

  func testSubscriptionCancellation() {
    let control = UIControl()
    let event: UIControl.Event = .touchUpInside
    var eventFired = false

    let cancellable: AnyCancellable = control.publisher(event)
      .sink { _ in
        eventFired = true
      }

    cancellable.cancel()
    control.sendActions(for: event)

    XCTAssertFalse(eventFired, "Event should not be received after the subscription is canceled")
  }
}
