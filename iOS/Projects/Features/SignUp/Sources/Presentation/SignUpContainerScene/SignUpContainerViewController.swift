//
//  SignUpContainerViewController.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - SignUpContainerViewController

public final class SignUpContainerViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let signUpGenderBirthViewController: SignUpGenderBirthViewController
  private let signUpProfileViewController: SignUpProfileViewController

  private lazy var gwPageControl: GWPageControl = {
    let gwPageControl = GWPageControl(count: viewControllers.count)
    gwPageControl.translatesAutoresizingMaskIntoConstraints = false
    return gwPageControl
  }()

  private lazy var pageViewController: UIPageViewController = {
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    pageViewController.dataSource = self
    pageViewController.delegate = self
    return pageViewController
  }()

  private lazy var viewControllers = [
    signUpGenderBirthViewController,
    signUpProfileViewController,
  ]

  public init(
    signUpGenderBirthViewController: SignUpGenderBirthViewController,
    signUpProfileViewController: SignUpProfileViewController
  ) {
    self.signUpGenderBirthViewController = signUpGenderBirthViewController
    self.signUpProfileViewController = signUpProfileViewController
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindUI()
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

private extension SignUpContainerViewController {
  func bindUI() {
    signUpGenderBirthViewController.genderBirthPublisher
      .sink { [weak self] _ in
        self?.scrollView(isEnabled: true)
        // TODO: genderBirth를 SignUpProfile까지 데이터를 넘겨줘서 User Entity로 합치기
      }
      .store(in: &subscriptions)

    signUpGenderBirthViewController.nextButtonTapPublisher
      .sink { [weak self] _ in
        self?.nextPage()
      }
      .store(in: &subscriptions)
  }
}

private extension SignUpContainerViewController {
  func configureUI() {
    view.backgroundColor = DesignSystemColor.secondaryBackground
    navigationController?.navigationBar.isHidden = true
    scrollView(isEnabled: false)
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(gwPageControl)
    NSLayoutConstraint.activate([
      gwPageControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.safeAreaInterval),
      gwPageControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
    ])

    if let viewController = viewControllers.first {
      pageViewController.setViewControllers([viewController], direction: .forward, animated: false)
    }

    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    add(child: pageViewController)
    NSLayoutConstraint.activate([
      pageViewController.view.topAnchor.constraint(equalTo: gwPageControl.bottomAnchor),
      pageViewController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      pageViewController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      pageViewController.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    ])
  }

  private func add(child viewController: UIViewController) {
    addChild(viewController)
    view.addSubview(viewController.view)
    viewController.didMove(toParent: viewController)
  }

  private func scrollView(isEnabled: Bool) {
    for view in pageViewController.view.subviews {
      if let scrollView = view as? UIScrollView {
        scrollView.isScrollEnabled = isEnabled
      }
    }
  }

  private func nextPage() {
    guard let currentViewController = pageViewController.viewControllers?.first,
          let currentIndex = viewControllers.firstIndex(of: currentViewController),
          currentIndex + 1 < viewControllers.count
    else {
      return
    }
    let count = viewControllers.count
    let nextViewController = viewControllers[currentIndex + 1]
    pageViewController.setViewControllers([nextViewController], direction: .forward, animated: false)
    gwPageControl.next()
  }
}

// MARK: UIPageViewControllerDelegate

extension SignUpContainerViewController: UIPageViewControllerDelegate {
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating _: Bool,
    previousViewControllers _: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    if completed,
       let currentViewController = pageViewController.viewControllers?.first,
       let currentIndex = viewControllers.firstIndex(of: currentViewController) {
      gwPageControl.select(at: currentIndex)
    }
  }
}

// MARK: UIPageViewControllerDataSource

extension SignUpContainerViewController: UIPageViewControllerDataSource {
  public func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = viewControllers.firstIndex(of: viewController),
          viewControllerIndex - 1 >= 0
    else {
      return nil
    }
    let previousIndex = viewControllerIndex - 1
    return viewControllers[previousIndex]
  }

  public func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewContollerIndex = viewControllers.firstIndex(of: viewController),
          viewContollerIndex + 1 < viewControllers.count
    else {
      return nil
    }
    let nextIndex = viewContollerIndex + 1
    return viewControllers[nextIndex]
  }
}

// MARK: - Metrics

private enum Metrics {
  static let pageControlInterval: CGFloat = 30
  static let safeAreaInterval: CGFloat = 24
  static let bottomInterval: CGFloat = 215
  static let calendarHeight: CGFloat = 51
}
