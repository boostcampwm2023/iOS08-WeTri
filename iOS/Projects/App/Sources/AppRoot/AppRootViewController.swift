//
//  AppRootViewController.swift
//  WeTri
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit
import WeTriArchitecture

// MARK: - AppRootPresentableListener

protocol AppRootPresentableListener: AnyObject {}

// MARK: - AppRootViewController

final class AppRootViewController: UITabBarController, AppRootPresentable, AppRootViewControllerRepresentable {
  // MARK: - Properties

  weak var listener: AppRootPresentableListener?

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: - UI Components

  // MARK: - Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    print(#function)
    setupLayouts()
    setupConstraints()
    setupStyles()
  }

  // MARK: - Configuration

  private func setupLayouts() {}

  private func setupConstraints() {}

  private func setupStyles() {
    tabBar.isTranslucent = true
    tabBar.tintColor = DesignSystemColor.primaryText
    tabBar.backgroundColor = DesignSystemColor.primaryBackGround

    view.backgroundColor = DesignSystemColor.primaryBackGround
  }

  func setupViewControllers(_ viewControllers: [ViewControllerRepresentable]) {
    print(#function)
    super.setViewControllers(viewControllers.map(\.viewController), animated: false)
  }
}
