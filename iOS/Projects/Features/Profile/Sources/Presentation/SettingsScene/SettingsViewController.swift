//
//  SettingsViewController.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

final class SettingsViewController: UIViewController {
  // MARK: Properties

  private let viewModel: SettingsViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let button: UIButton = .init(configuration: .mainEnabled(title: "test button"))

  // MARK: Initializations

  deinit {
    Log.make().debug("\(Self.self) deinitialized")
  }

  init(viewModel: SettingsViewModelRepresentable) {
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
    setupStyles()
    bind()
  }

  // MARK: Configuration

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.tintColor = DesignSystemColor.primaryText
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.backButtonDisplayMode = .minimal
    navigationItem.title = "설정"
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
