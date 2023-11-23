//
//  WorkoutSessionContainerViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WorkoutSessionContainerViewController

final class WorkoutSessionContainerViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutSessionContainerViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private let endWorkoutSubject: PassthroughSubject<Void, Never> = .init()

  // MARK: UI Components

  private let viewControllers: [UIViewController] = [
    WorkoutSessionViewController(viewModel: WorkoutSessionViewModel()),
    WorkoutRouteMapViewController(viewModel: WorkoutRouteMapViewModel()),
  ]

  private let recordTimerLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.text = "0분 0초"
    return label
  }()

  private lazy var endWorkoutButton: UIButton = {
    let button = UIButton(configuration: .mainCircularEnabled(title: "종료"))
    button.configuration?.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
    button.accessibilityHint = "운동을 종료합니다."
    return button
  }()

  private lazy var pageViewController: UIPageViewController = {
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    pageViewController.dataSource = self
    return pageViewController
  }()

  // MARK: Initializations

  init(viewModel: WorkoutSessionContainerViewModelRepresentable) {
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
    addChild(pageViewController)
    view.addSubview(recordTimerLabel)
    view.addSubview(pageViewController.view)
    view.addSubview(endWorkoutButton)
    pageViewController.didMove(toParent: self)

    if let firstViewController = viewControllers.first {
      pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false)
    }
  }

  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    recordTimerLabel.translatesAutoresizingMaskIntoConstraints = false
    endWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        recordTimerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        recordTimerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
        recordTimerLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.recordTimerLabelTop),

        pageViewController.view.topAnchor.constraint(equalTo: recordTimerLabel.bottomAnchor, constant: Metrics.pageViewControllerTop),
        pageViewController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        pageViewController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
        pageViewController.view.bottomAnchor.constraint(equalTo: endWorkoutButton.topAnchor, constant: -Metrics.pageViewControllerBottom),

        endWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        endWorkoutButton.widthAnchor.constraint(equalToConstant: Metrics.endingWorkoutButtonSize),
        endWorkoutButton.heightAnchor.constraint(equalToConstant: Metrics.endingWorkoutButtonSize),
        endWorkoutButton.bottomAnchor.constraint(
          equalTo: safeArea.bottomAnchor,
          constant: -Metrics.endingWorkoutButtonBottom
        ),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  private func bind() {
    let output = viewModel.transform(input: .init(endWorkoutPublisher: endWorkoutSubject.eraseToAnyPublisher()))
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }
}

// MARK: UIPageViewControllerDataSource

extension WorkoutSessionContainerViewController: UIPageViewControllerDataSource {
  func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {
      return nil
    }

    let previousIndex = viewControllerIndex - 1

    guard previousIndex >= 0 else {
      return nil
    }

    guard viewControllers.count > previousIndex else {
      return nil
    }

    return viewControllers[previousIndex]
  }

  func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {
      return nil
    }

    let nextIndex = viewControllerIndex + 1
    let viewControllersCount = viewControllers.count

    guard viewControllersCount != nextIndex else {
      return nil
    }

    guard viewControllersCount > nextIndex else {
      return nil
    }

    return viewControllers[nextIndex]
  }
}

// MARK: WorkoutSessionContainerViewController.Metrics

private extension WorkoutSessionContainerViewController {
  enum Metrics {
    static let horizontal: CGFloat = 36
    static let recordTimerLabelTop: CGFloat = 12
    static let pageViewControllerTop: CGFloat = 12
    static let pageViewControllerBottom: CGFloat = 24
    static let endingWorkoutButtonBottom: CGFloat = 32

    static let endingWorkoutButtonSize: CGFloat = 150
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
#Preview {
  WorkoutSessionContainerViewController(viewModel: WorkoutSessionContainerViewModel())
}
