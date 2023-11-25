//
//  WorkoutPeerRandomMatchingViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WorkoutPeerRandomMatchingViewController

final class WorkoutPeerRandomMatchingViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutPeerRandomMatchingViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let matchingDescriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "초기 값 입니다."
    label.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
    label.contentMode = .scaleAspectFit
    label.numberOfLines = 1
    label.textColor = DesignSystemColor.secondaryBackground

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = false
    activityIndicator.style = .medium
    activityIndicator.color = .white
    activityIndicator.startAnimating()

    return activityIndicator

  }()

  private let cancelButton: UIButton = {
    let button = UIButton(configuration: .filled())
    button.backgroundColor = DesignSystemColor.primaryBackground
    button.setTitle("취소", for: .normal)

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  // MARK: Initializations

  init(viewModel: WorkoutPeerRandomMatchingViewModelRepresentable) {
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
    setupHierarchyAndConstraints()
    bind()
  }

  // MARK: Configuration

  private func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    view.addSubview(matchingDescriptionLabel)
    view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.labelTopConstraints).isActive = true

    view.addSubview(activityIndicator)
    activityIndicator.topAnchor.constraint(equalTo: matchingDescriptionLabel.bottomAnchor, constant: Metrics.indicatorTopConstraintsFromLabel).isActive = true
    activityIndicator.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    activityIndicator.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
  }

  private func setupConstraints() {}

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryText.withAlphaComponent(0.8)
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

// MARK: WorkoutPeerRandomMatchingViewController.Metrics

private extension WorkoutPeerRandomMatchingViewController {
  enum Metrics {
    static let labelTopConstraints: CGFloat = 180
    static let indicatorTopConstraintsFromLabel: CGFloat = 15
  }
}
