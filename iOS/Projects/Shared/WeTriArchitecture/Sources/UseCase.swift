//
//  UseCase.swift
//  WeTriArchitecture
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - UseCaseRepresentable

public protocol UseCaseRepresentable: AnyObject {
  func activate()

  func deactivate()
}

// MARK: - UseCase

open class UseCase<ViewModelType>: UseCaseRepresentable {
  // MARK: Properties

  private let isActiveSubject: CurrentValueSubject<Bool, Never> = .init(false)

  private var subscriptions: Set<AnyCancellable> = []

  public final var isActive: Bool {
    return isActiveSubject.value
  }

  public let viewModel: ViewModelType

  // MARK: Initializations

  public init(viewModel: ViewModelType) {
    self.viewModel = viewModel
  }

  deinit {
    if isActive {
      deactivate()
    }
    isActiveSubject.send(completion: .finished)
  }

  // MARK: - Public Methods

  public func activate() {
    if isActive { return }
    isActiveSubject.send(true)

    didBecomeActive()
  }

  public func deactivate() {
    guard isActive else { return }

    willResignActive()

    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    isActiveSubject.send(false)
  }

  open func didBecomeActive() {}

  open func willResignActive() {}
}
