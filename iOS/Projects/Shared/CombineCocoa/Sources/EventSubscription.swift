//
//  EventSubscription.swift
//  TNCocoaCombine
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import UIKit

final class EventSubscription<EventSubscriber: Subscriber>:
  Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
  func request(_: Subscribers.Demand) {}

  func cancel() {
    subscriber = nil
    control.removeAction(action, for: event)
  }

  private let control: UIControl
  private let event: UIControl.Event
  private var subscriber: EventSubscriber?
  private let action: UIAction

  init(control: UIControl, event: UIControl.Event, subscriber: EventSubscriber) {
    self.control = control
    self.event = event
    self.subscriber = subscriber
    action = .init { _ in
      _ = subscriber.receive(control)
    }

    control.addAction(action, for: event)
  }
}
