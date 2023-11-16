//
//  WorkoutSummaryViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit
import WeTriArchitecture

// MARK: - WorkoutSummaryViewController

public final class WorkoutSummaryViewController: UIViewController, WorkoutSummaryViewControllerRepresentable {
  // MARK: - Properties

  private let viewModel: WorkoutSummaryViewModelRepresentable

  private let exitWorkout = PassthroughSubject<Void, Never>()

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: - UI Components

  private let button: UIButton = .init(configuration: .mainEnabled(title: "테스트"))

  // MARK: - Initializations

  init(viewModel: WorkoutSummaryViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    title = "요약"
    tabBarItem = .init(title: "요약", image: .init(systemName: "figure.run.circle"), selectedImage: .init(systemName: "figure.run.circle.fill"))
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
    view.backgroundColor = DesignSystemColor.main02
  }

  private func bind() {
    button.addAction(UIAction { [weak self] _ in
      self?.exitWorkout.send(())
    }, for: .touchUpInside)
    let output = viewModel.transform(input: .init(workoutFinished: exitWorkout.eraseToAnyPublisher()))
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  public func pushToScreen(_ viewController: ViewControllerRepresentable) {
    navigationController?.pushViewController(viewController.viewController, animated: true)
//    present(viewController.viewController, animated: true)
  }
}
