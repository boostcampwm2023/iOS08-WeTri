//
//  WorkoutSessionContainerViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineExtension
import DesignSystem
import Log
import UIKit

// MARK: - WorkoutSessionContainerViewController

final class WorkoutSessionContainerViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutSessionContainerViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private let endWorkoutSubject: PassthroughSubject<Void, Never> = .init()

  // MARK: UI Components - ViewController

  private let sessionViewController: HealthDataProtocol

  private let routeMapViewController: LocationTrackingProtocol

  private lazy var viewControllers: [UIViewController] = [
    sessionViewController,
    routeMapViewController,
  ]

  private lazy var pageViewController: UIPageViewController = {
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    pageViewController.dataSource = self
    pageViewController.delegate = self
    return pageViewController
  }()

  // MARK: UI Components

  private let recordTimerLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.text = "00분 00초"
    return label
  }()

  private lazy var endWorkoutButton: UIButton = {
    let button = UIButton(configuration: .mainCircularEnabled(title: "종료"))
    button.configuration?.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
    button.accessibilityHint = "운동을 종료합니다."
    return button
  }()

  private lazy var pageControl: GWPageControl = .init(count: viewControllers.count)

  // MARK: Initializations

  init(
    viewModel: WorkoutSessionContainerViewModelRepresentable,
    healthDataProtocol: HealthDataProtocol,
    locationTrackingProtocol: LocationTrackingProtocol
  ) {
    self.viewModel = viewModel
    sessionViewController = healthDataProtocol
    routeMapViewController = locationTrackingProtocol
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    Log.make().debug("\(Self.self) deinitialized")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    routeMapViewController.view.layoutIfNeeded()
  }

  // MARK: Configuration

  private func setupLayouts() {
    addChild(pageViewController)
    view.addSubview(recordTimerLabel)
    view.addSubview(pageViewController.view)
    view.addSubview(pageControl)
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
    pageControl.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        recordTimerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        recordTimerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
        recordTimerLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.recordTimerLabelTop),

        pageViewController.view.topAnchor.constraint(equalTo: recordTimerLabel.bottomAnchor, constant: Metrics.pageViewControllerTop),
        pageViewController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        pageViewController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
        pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -Metrics.pageViewControllerBottom),

        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        pageControl.bottomAnchor.constraint(equalTo: endWorkoutButton.topAnchor, constant: -Metrics.pageControlBottom),
        pageControl.heightAnchor.constraint(equalToConstant: Metrics.pageControlHeight),

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
    navigationController?.isNavigationBarHidden = true
  }

  private func bind() {
    endWorkoutButton.publisher(.touchUpInside)
      .map { _ in }
      .bind(to: endWorkoutSubject)
      .store(in: &subscriptions)

    let output = viewModel.transform(
      input: .init(
        endWorkoutPublisher: endWorkoutSubject.eraseToAnyPublisher(),
        locationPublisher: routeMapViewController.locationPublisher,
        mapCaptureImageDataPublisher: routeMapViewController.mapCaptureData,
        healthPublisher: sessionViewController.healthDataPublisher
      )
    )

    output
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .idle: break
        case let .updateTime(elapsedTime): self?.updateRecordTimerLabel(elapsedTime: elapsedTime)
        case let .alert(error): self?.showAlert(with: error)
        }
      }
      .store(in: &subscriptions)

    endWorkoutSubject
      .sink(receiveValue: routeMapViewController.requestCapture)
      .store(in: &subscriptions)
  }

  // MARK: - Custom Methods

  private func updateRecordTimerLabel(elapsedTime: Int) {
    let minutes = elapsedTime / 60 % 60
    let seconds = elapsedTime % 60
    recordTimerLabel.text = String(format: "%02d분 %02d초", minutes, seconds)
  }

  /// 에러 알림 문구를 보여줍니다.
  private func showAlert(with error: Error) {
    Log.make().debug("\(error)")
    let alertController = UIAlertController(title: "알림", message: String(describing: error), preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "확인", style: .default))
    present(alertController, animated: true)
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

// MARK: UIPageViewControllerDelegate

extension WorkoutSessionContainerViewController: UIPageViewControllerDelegate {
  func pageViewController(_: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
    if completed,
       let visibleViewController = pageViewController.viewControllers?.first,
       let index = viewControllers.firstIndex(of: visibleViewController) {
      pageControl.select(at: index)
    }
  }
}

// MARK: WorkoutSessionContainerViewController.Metrics

private extension WorkoutSessionContainerViewController {
  enum Metrics {
    static let horizontal: CGFloat = 36
    static let recordTimerLabelTop: CGFloat = 12
    static let pageViewControllerTop: CGFloat = 12
    static let pageViewControllerBottom: CGFloat = 24
    static let pageControlBottom: CGFloat = 12
    static let endingWorkoutButtonBottom: CGFloat = 32

    static let endingWorkoutButtonSize: CGFloat = 150
    static let pageControlHeight: CGFloat = 8
  }
}
