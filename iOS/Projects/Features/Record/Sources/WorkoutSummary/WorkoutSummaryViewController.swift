//
//  WorkoutSummaryViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WorkoutSummaryViewController

public final class WorkoutSummaryViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutSummaryViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let recordTimerLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.text = "0분 0초"
    return label
  }()

  private let endingWorkoutButton: UIButton = {
    let button = UIButton(configuration: .mainCircularEnabled(title: "종료"))
    button.configuration?.font = .preferredFont(forTextStyle: .largeTitle, with: .traitBold)
    return button
  }()

  // MARK: Initializations

  public init(viewModel: WorkoutSummaryViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
  }

  // MARK: Configuration

  private func setupLayouts() {
    view.addSubview(endingWorkoutButton)
    view.addSubview(recordTimerLabel)
  }

  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    recordTimerLabel.translatesAutoresizingMaskIntoConstraints = false
    endingWorkoutButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        recordTimerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        recordTimerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
        recordTimerLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.recordTimerLabelTop),

        endingWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        endingWorkoutButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.endingWorkoutButtonBottom),
        endingWorkoutButton.widthAnchor.constraint(equalToConstant: Metrics.endingWorkoutButtonSize),
        endingWorkoutButton.heightAnchor.constraint(equalToConstant: Metrics.endingWorkoutButtonSize),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackGround
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

// MARK: WorkoutSummaryViewController.Metrics

private extension WorkoutSummaryViewController {
  enum Metrics {
    static let recordTimerLabelTop: CGFloat = 12
    static let horizontal: CGFloat = 36
    static let endingWorkoutButtonSize: CGFloat = 150
    static let endingWorkoutButtonBottom: CGFloat = 32
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
#Preview {
  WorkoutSummaryViewController(viewModel: WorkoutSummaryViewModel())
}
