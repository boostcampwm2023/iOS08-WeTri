//
//  EventSubscription.swift
//  TNCocoaCombine
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import UIKit

class EventSubscription<EventSubscriber: Subscriber>:
  Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
  func request(_: Subscribers.Demand) {}

  func cancel() {
    subscriber = nil
    control.removeTarget(self, action: #selector(eventDidOccur), for: event)
  }

  @objc func eventDidOccur() {
    _ = subscriber?.receive(control)
  }

  let control: UIControl
  let event: UIControl.Event
  var subscriber: EventSubscriber?

  init(control: UIControl, event: UIControl.Event, subscriber: EventSubscriber) {
    self.control = control
    self.event = event
    self.subscriber = subscriber

    control.addTarget(self, action: #selector(eventDidOccur), for: event)
  }
}
