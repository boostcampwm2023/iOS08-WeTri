//
//  WorkoutPeerRandomMatchingViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineExtension
import CommonNetworkingKeyManager
import DesignSystem
import Keychain
import UIKit

// MARK: - WorkoutPeerRandomMatchingViewController

final class WorkoutPeerRandomMatchingViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutPeerRandomMatchingViewModelRepresentable

  private let cancelButtonDidTapPublisher = PassthroughSubject<Void, Never>()

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let matchingDescriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "초기 값 입니다."
    label.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
    label.contentMode = .scaleAspectFit
    label.numberOfLines = 1
    label.textAlignment = .center
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
    activityIndicator.transform = .init(scaleX: 2, y: 2)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicator

  }()

  private let cancelButton: UIButton = {
    let button = UIButton(configuration: .filled())
    var configuration = button.configuration
    configuration?.baseBackgroundColor = DesignSystemColor.primaryBackground
    configuration?.title = "취소"
    configuration?.font = .preferredFont(forTextStyle: .headline, weight: .bold)
    configuration?.attributedTitle?.foregroundColor = DesignSystemColor.primaryText
    button.configuration = configuration

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  // MARK: Initializations

  init(viewModel: WorkoutPeerRandomMatchingViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

    let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkMDA0MmFjZC02YTc0LTRjMDItYTdmZi1iYzU2YzZhYzQzZjQiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNzAxOTk5NTA2LCJleHAiOjE3MDIwMDMxMDZ9.wpfTVubkyQFTcVSFTgigjhCX1gwm7TFc98cEZMzS-UU".data(using: .utf8)!
    Keychain.shared.save(key: Tokens.accessToken, data: accessToken)

    let refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkMDA0MmFjZC02YTc0LTRjMDItYTdmZi1iYzU2YzZhYzQzZjQiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcwMTk5OTUwNiwiZXhwIjoxNzAyMDg1OTA2fQ.1-_8mVenoS7uUuuGedOlG_Ng7xHHYEmX5Kpw5Z8XJls".data(using: .utf8)!
    Keychain.shared.save(key: Tokens.refreshToken, data: refreshToken)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

private extension WorkoutPeerRandomMatchingViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
    didTapCancelButton()
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryText.withAlphaComponent(0.9)
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(matchingDescriptionLabel)
    matchingDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Metrics.labelTopConstraints).isActive = true
    matchingDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    matchingDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    view.addSubview(activityIndicator)
    activityIndicator.topAnchor
      .constraint(equalTo: matchingDescriptionLabel.bottomAnchor, constant: Metrics.componentSpacing).isActive = true
    activityIndicator.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    activityIndicator.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    view.addSubview(cancelButton)
    cancelButton.topAnchor
      .constraint(equalTo: activityIndicator.bottomAnchor, constant: Metrics.componentSpacing).isActive = true
    cancelButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
  }

  func bind() {
    let input = WorkoutPeerRandomMatchingViewModelInput(
      cancelPublisher: cancelButtonDidTapPublisher.eraseToAnyPublisher()
    )

    let output = viewModel.transform(input: input)
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  func didTapCancelButton() {
    cancelButton.publisher(.touchUpInside)
      .map { _ in () }
      .bind(to: cancelButtonDidTapPublisher)
      .store(in: &subscriptions)
  }
}

// MARK: WorkoutPeerRandomMatchingViewController.Metrics

private extension WorkoutPeerRandomMatchingViewController {
  enum Metrics {
    static let labelTopConstraints: CGFloat = 222
    static let componentSpacing: CGFloat = 30
  }
}
