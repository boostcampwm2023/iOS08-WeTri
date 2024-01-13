//
//  GestureSubscription.swift
//  CombineCocoa
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import UIKit

final class GestureSubscription<T: Subscriber>: Subscription where T.Input == UIGestureRecognizer, T.Failure == Never {
  var subscriber: T?
  let gesture: UIGestureRecognizer
  var targetView: UIView?

  @objc func action() {
    _ = subscriber?.receive(gesture)
  }

  init(subscriber: T, gesture: UIGestureRecognizer, targetView: UIView) {
    self.subscriber = subscriber
    self.gesture = gesture
    self.targetView = targetView

    gesture.addTarget(self, action: #selector(action))
    targetView.addGestureRecognizer(gesture)
  }

  func request(_: Subscribers.Demand) {}

  func cancel() {
    gesture.removeTarget(self, action: #selector(action))
    targetView?.removeGestureRecognizer(gesture)
    targetView = nil
    subscriber = nil
  }
}
