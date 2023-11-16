//
//  Coordinator.swift
//  WeTriArchitecture
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - Coordinating

public protocol Coordinating: AnyObject {
  var useCaseRepresentable: UseCaseRepresentable { get }

  var viewControllerRepresentable: ViewControllerRepresentable { get }

  var children: [Coordinating] { get }

  func load()

  func attachChild(_ child: Coordinating)

  func detachChild(_ child: Coordinating)
}

// MARK: - Coordinator

open class Coordinator<UseCaseType, ViewControllerType>: Coordinating {
  // MARK: Properties

  private var didLoadFlag: Bool = false

  public let useCaseRepresentable: UseCaseRepresentable

  public let useCase: UseCaseType

  public let viewControllerRepresentable: ViewControllerRepresentable

  public let viewController: ViewControllerType

  public final var children: [Coordinating] = []

  // MARK: - Initializations

  public init(useCase: UseCaseType, viewController: ViewControllerType) {
    self.useCase = useCase
    self.viewController = viewController
    guard let useCaseRepresentable = useCase as? UseCaseRepresentable else {
      fatalError("\(useCase)는 \(UseCaseRepresentable.self)를 conform해야합니다.")
    }

    guard let viewControllerRepresentable = viewController as? ViewControllerRepresentable else {
      fatalError("\(viewController)는 \(ViewControllerRepresentable.self)를 conform해야합니다.")
    }

    self.useCaseRepresentable = useCaseRepresentable
    self.viewControllerRepresentable = viewControllerRepresentable
  }

  deinit {
    useCaseRepresentable.deactivate()

    if !children.isEmpty {
      for child in children {
        detachChild(child)
      }
    }
  }

  // MARK: - Methods

  open func didLoad() {}
}

public extension Coordinator {
  final func load() {
    if didLoadFlag { return }
    didLoadFlag = true
    didLoad()
  }

  func attachChild(_ child: Coordinating) {
    guard
      children.contains(where: { $0 === child }) == false
    else {
      // TODO: Logger 구현 필요 - "Attempt to attach child: \(child), which is already attached to \(self).")
      return
    }
    children.append(child)
    child.useCaseRepresentable.activate()
    child.load()
  }

  func detachChild(_ child: Coordinating) {
    child.useCaseRepresentable.deactivate()

    guard let index = children.firstIndex(where: { $0 === child }) else {
      // TODO: Logger 구현 필요 - Coordinator 연속 제거 시도 중
      return
    }
    children.remove(at: index)
  }
}
