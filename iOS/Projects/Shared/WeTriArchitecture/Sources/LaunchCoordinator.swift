//
//  LaunchCoordinator.swift
//  WeTriArchitecture
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import class UIKit.UIWindow

// MARK: - LaunchCoordinating

public protocol LaunchCoordinating {
  func launch(from window: UIWindow)
}

// MARK: - LaunchCoordinator

open class LaunchCoordinator<UseCaseType, ViewControllerType>: Coordinator<UseCaseType, ViewControllerType>, LaunchCoordinating {
  override public init(useCase: UseCaseType, viewController: ViewControllerType) {
    super.init(useCase: useCase, viewController: viewController)
  }

  public func launch(from window: UIWindow) {
    window.rootViewController = viewControllerRepresentable.viewController
    window.makeKeyAndVisible()

    useCaseRepresentable.activate()
    load()
  }
}
