// 
//  SplashViewController.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

final class SplashViewController: UIViewController {

  // MARK: Properties

  private let viewModel: SplashViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let button: UIButton = .init(configuration: .mainEnabled(title: "test button"))

  // MARK: Initializations

  init(viewModel: SplashViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
  }

  // MARK: Configuration

  private func setupLayouts() {
    view.addSubview(button)
  }

  private func setupConstraints() {
    button.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  private func bind() {
    let output = viewModel.transform(input: .init())
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
#Preview {
  SplashViewController(viewModel: SplashViewModel())
}
