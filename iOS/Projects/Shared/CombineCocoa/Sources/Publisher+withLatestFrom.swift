//
//  Publisher+withLatestFrom.swift
//  CombineCocoa
//
//  Created by 홍승현 on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

public extension Publisher {
  func withLatestFrom<Other: Publisher, Result>(
    _ other: Other,
    transform: @escaping (Output, Other.Output) -> Result
  ) -> Publishers.WithLatestFrom<Self, Other, Result> {
    return .init(upstream: self, other: other, resultClosure: transform)
  }

  func withLatestFrom<Other: Publisher>(_ other: Other) -> Publishers.WithLatestFrom<Self, Other, Other.Output> {
    return .init(upstream: self, other: other) { $1 }
  }
}

// MARK: - Publishers.WithLatestFrom

public extension Publishers {
  struct WithLatestFrom<Upstream: Publisher, Other: Publisher, Output>: Publisher where Upstream.Failure == Other.Failure {
    /// The kind of errors this publisher might publish.
    ///
    /// This publisher produces the failure type shared by its upstream publishers.
    public typealias Failure = Upstream.Failure

    public let upstream: Upstream
    public let other: Other
    public let resultClosure: (Upstream.Output, Other.Output) -> Output

    public init(
      upstream: Upstream,
      other: Other,
      resultClosure: @escaping (Upstream.Output, Other.Output) -> Output
    ) {
      self.upstream = upstream
      self.other = other
      self.resultClosure = resultClosure
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Upstream.Failure == S.Failure, Output == S.Input {
      let subscription = WithLatestFromSubscription(
        subscriber: subscriber,
        resultClosure: resultClosure,
        upstream: upstream,
        other: other
      )
      subscriber.receive(subscription: subscription)
    }
  }
}

// MARK: - Publishers.WithLatestFrom.WithLatestFromSubscription

private extension Publishers.WithLatestFrom {
  final class WithLatestFromSubscription<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure {
    private let subscriber: S
    private let resultClosure: (Upstream.Output, Other.Output) -> Output
    private let upstream: Upstream
    private let other: Other
    private var otherLatestValue: Other.Output?

    private var upstreamSubscription: Cancellable?
    private var otherSubscription: Cancellable?

    init(
      subscriber: S,
      resultClosure: @escaping (Upstream.Output, Other.Output) -> Output,
      upstream: Upstream,
      other: Other
    ) {
      self.subscriber = subscriber
      self.resultClosure = resultClosure
      self.upstream = upstream
      self.other = other
      trackLatestFromOther()
    }

    private func trackLatestFromOther() {
      let subscriber = AnySubscriber<Other.Output, Other.Failure> { [weak self] subscription in
        self?.otherSubscription = subscription
        subscription.request(.unlimited)
      } receiveValue: { [weak self] output in
        self?.otherLatestValue = output
        return .unlimited
      }

      other.subscribe(subscriber)
    }

    func request(_: Subscribers.Demand) {
      upstreamSubscription = upstream
        .sink { [subscriber] completion in
          subscriber.receive(completion: completion)
        } receiveValue: { [weak self] output in
          guard let self,
                let otherLatestValue
          else { return }
          _ = subscriber.receive(resultClosure(output, otherLatestValue))
        }
    }

    func cancel() {
      upstreamSubscription = nil
      otherSubscription = nil
    }
  }
}
