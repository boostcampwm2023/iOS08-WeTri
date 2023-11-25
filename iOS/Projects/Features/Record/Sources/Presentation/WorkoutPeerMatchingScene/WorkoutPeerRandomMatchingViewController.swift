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

// dim뷰 일종의 UIView를 만들어서 처리

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
    button.configuration = configuration

    button.setTitle("취소", for: .normal)
    button.titleLabel?.font = .preferredFont(forTextStyle: .headline, weight: .bold)
    button.setTitleColor(DesignSystemColor.primaryText, for: .normal)

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
      .sink { [weak self] _ in
        self?.cancelButtonDidTapPublisher.send(())
      }
      .store(in: &subscriptions)
  }
}

// MARK: WorkoutPeerRandomMatchingViewController.Metrics

private extension WorkoutPeerRandomMatchingViewController {
  enum Metrics {
    static let labelTopConstraints: CGFloat = 180
    static let componentSpacing: CGFloat = 30
  }
}
