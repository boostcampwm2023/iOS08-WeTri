//
//  UIControl+Publisher.swift
//  TNCocoaCombine
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import UIKit

public extension UIControl {
  func publisher(_ event: UIControl.Event) -> EventPublisher {
    return EventPublisher(control: self, event: event)
  }

  struct EventPublisher: Publisher {
    public typealias Output = UIControl
    public typealias Failure = Never

    let control: UIControl
    let event: UIControl.Event

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
      let subscription = EventSubscription(control: control, event: event, subscriber: subscriber)
      subscriber.receive(subscription: subscription)
    }
  }
}
