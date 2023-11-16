//
//  WorkoutResultViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WorkoutResultViewController

public final class WorkoutResultViewController: UIViewController, WorkoutResultViewControllerRepresentable {
  // MARK: - Properties

  private let viewModel: WorkoutResultViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: - UI Components

  private let label: UILabel = {
    let label = UILabel()
    label.text = "Hello, World!"
    label.textAlignment = .center
    return label
  }()

  // MARK: - Initializations

  public init(viewModel: WorkoutResultViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    title = "결과"
    tabBarItem = .init(title: "결과", image: .init(systemName: "person.text.rectangle"), selectedImage: .init(systemName: "person.text.rectangle.fill"))
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life Cycles

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
  }

  // MARK: - Configuration

  private func setupLayouts() {
    view.addSubview(label)
  }

  private func setupConstraints() {
    label.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.main03
  }

  private func bind() {}
}
