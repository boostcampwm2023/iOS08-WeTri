//
//  WorkoutEnvironmentSetupViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineExtension
import DesignSystem
import UIKit

// MARK: - WorkoutEnvironmentSetupViewController

public final class WorkoutEnvironmentSetupViewController: UIViewController {
  init(viewModel: WorkoutEnvironmentSetupViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    setup()
    requestWorkoutTypes.send()
    requestWorkoutPeerTypes.send()
  }

  private var subscriptions = Set<AnyCancellable>()
  private let viewModel: WorkoutEnvironmentSetupViewModelRepresentable?

  // MARK: - WorkoutEnvironmentSetupViewModelInput

  private let requestWorkoutTypes = PassthroughSubject<Void, Never>()
  private let requestWorkoutPeerTypes = PassthroughSubject<Void, Never>()
  private let selectWorkoutType = PassthroughSubject<WorkoutType?, Never>()
  private let selectPeerType = PassthroughSubject<PeerType?, Never>()
  private let endWorkoutEnvironment = PassthroughSubject<Void, Never>()
  private let didTapStartButton = PassthroughSubject<Void, Never>()

  // MARK: - ConatinerViewController Control Property

  private var workoutTypesDataSource: UICollectionViewDiffableDataSource<Int, WorkoutType>?
  private var workoutPeerTypesDataSource: UICollectionViewDiffableDataSource<Int, PeerType>?

  private var workoutTypesCollectionView: UICollectionView?
  private var workoutPeerTypesCollectionView: UICollectionView?

  private let workoutSelectViewController = WorkoutSelectViewController()
  private let workoutPeerSelectViewController = WorkoutPeerSelectViewController()
  private lazy var contentViewControllers = [workoutSelectViewController, workoutPeerSelectViewController]
  private var pageScrollView: UIScrollView? = nil

  private let gwPageControl: GWPageControl = {
    let pageControl = GWPageControl(count: Constant.countOfPage)

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()

  private lazy var pageViewController: UIPageViewController = {
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    pageViewController.dataSource = self
    pageViewController.delegate = self

    let scrollView = pageViewController.view.subviews
      .compactMap { $0 as? UIScrollView }
      .first
    pageScrollView = scrollView
    pageScrollView?.isScrollEnabled = false
    pageScrollView?.delegate = self

    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    return pageViewController
  }()
}

private extension WorkoutEnvironmentSetupViewController {
  func setup() {
    setupStyle()
    setupViewHierarchyAndConstraints()
    bind()

    configureDataSource()
  }

  func setupStyle() {
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = DesignSystemColor.main03

    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(gwPageControl)
    gwPageControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
    gwPageControl.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value + 11).isActive = true
    gwPageControl.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    gwPageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

    view.addSubview(pageViewController.view)
    if let viewController = contentViewControllers.first {
      pageViewController.setViewControllers([viewController], direction: .forward, animated: false)
    }
    pageViewController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    pageViewController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    pageViewController.view.topAnchor.constraint(equalTo: gwPageControl.bottomAnchor).isActive = true
    pageViewController.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }

  func bind() {
    workoutSelectViewController.delegate = self

    workoutTypesCollectionView = workoutSelectViewController.workoutTypesCollectionView
    workoutTypesCollectionView?.delegate = self

    workoutPeerTypesCollectionView = workoutPeerSelectViewController.pearTypeSelectCollectionView
    workoutPeerTypesCollectionView?.delegate = self

    bindViewModel()
    bindStartButton()
  }

  func bindStartButton() {
    workoutPeerSelectViewController
      .startButtonDidTapPublisher()
      .bind(to: didTapStartButton)
      .store(in: &subscriptions)
  }

  func bindViewModel() {
    guard let viewModel else { return }
    subscriptions.removeAll()

    let input = WorkoutEnvironmentSetupViewModelInput(
      requestWorkoutTypes: requestWorkoutTypes.eraseToAnyPublisher(),
      requestWorkoutPeerTypes: requestWorkoutPeerTypes.eraseToAnyPublisher(),
      endWorkoutEnvironment: endWorkoutEnvironment.eraseToAnyPublisher(),
      selectWorkoutType: selectWorkoutType.eraseToAnyPublisher(),
      selectPeerType: selectPeerType.eraseToAnyPublisher(),
      didTapStartButton: didTapStartButton.eraseToAnyPublisher()
    )

    let output = viewModel.transform(input: input)

    output
      .sink { [weak self] state in
        guard let self else { return }
        switch state {
        // TODO: failure에 알맞는 로직 세우기
        case .error,
             .idle: break
        case let .workoutTypes(workoutTypes): updateWorkout(types: workoutTypes)
        case let .workoutPeerTypes(peer): updateWorkoutPeer(types: peer)
        case let .didSelectWorkoutType(bool): workoutSelectViewController.nextButtonEnable(bool)
        case let .didSelectWorkoutPeerType(bool): workoutPeerSelectViewController.startButtonEnable(bool)
        }
      }
      .store(in: &subscriptions)
  }

  func configureDataSource() {
    configureWorkoutTypesDataSource()
    configureWorkoutPeerTypesDataSource()
  }

  func configureWorkoutTypesDataSource() {
    guard let workoutTypesCollectionView else {
      return
    }

    workoutTypesDataSource = .init(collectionView: workoutTypesCollectionView) { collectionView, indexPath, item in
      guard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutSelectTypeCell.identifier, for: indexPath) as? WorkoutSelectTypeCell
      else {
        return UICollectionViewCell()
      }

      cell.update(
        systemName: item.workoutIcon,
        description: item.workoutTitle,
        typeCode: item.typeCode
      )
      return cell
    }
  }

  func configureWorkoutPeerTypesDataSource() {
    guard let workoutPeerTypesCollectionView else {
      return
    }

    workoutPeerTypesDataSource = .init(collectionView: workoutPeerTypesCollectionView) { collectionView, indexPath, itemIdentifier in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutPeerTypeSelectCell.identifier, for: indexPath)
        as? WorkoutPeerTypeSelectCell
      else {
        return UICollectionViewCell()
      }

      cell.update(
        descriptionIconSystemName: itemIdentifier.iconSystemImage,
        descriptionTitleText: itemIdentifier.titleText,
        descriptionSubTitleText: itemIdentifier.descriptionText,
        typeCode: itemIdentifier.typeCode
      )
      return cell
    }
  }

  enum Constant {
    static let countOfPage = 2
  }
}

// MARK: updateContainerViewController Cell

private extension WorkoutEnvironmentSetupViewController {
  func updateWorkoutPeer(types: [PeerType]) {
    guard let workoutPeerTypesDataSource else { return }
    var snapshot = workoutPeerTypesDataSource.snapshot()
    snapshot.deleteAllItems()
    snapshot.appendSections([0])

    // 중복 데이터 및 타입코드 순서에 맞게 정렬합니다.
    let targetTypes = Array(Set(types))
      .sorted { $0.typeCode < $1.typeCode }
    snapshot.appendItems(targetTypes)

    DispatchQueue.main.async {
      workoutPeerTypesDataSource.apply(snapshot)
    }
  }

  func updateWorkout(types: [WorkoutType]) {
    guard let workoutTypesDataSource else { return }
    var snapshot = workoutTypesDataSource.snapshot()
    snapshot.deleteAllItems()
    snapshot.appendSections([0])

    let targetTypes = Array(Set(types))
      .sorted { $0.typeCode < $1.typeCode }
    snapshot.appendItems(targetTypes)

    DispatchQueue.main.async {
      workoutTypesDataSource.apply(snapshot)
    }
  }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension WorkoutEnvironmentSetupViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating _: Bool,
    previousViewControllers _: [UIViewController],
    transitionCompleted _: Bool
  ) {
    if
      let currentViewController = pageViewController.viewControllers?.first,
      let currentIndex = contentViewControllers.firstIndex(of: currentViewController) {
      pageScrollView?.isScrollEnabled = currentIndex == 0 ? false : true
      gwPageControl.select(at: currentIndex)
    }
  }

  public func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard
      let viewControllerIndex = contentViewControllers.firstIndex(of: viewController),
      viewControllerIndex - 1 >= 0
    else {
      return nil
    }
    let previousIndex = viewControllerIndex - 1
    return contentViewControllers[previousIndex]
  }

  public func pageViewController(_: UIPageViewController, viewControllerAfter _: UIViewController) -> UIViewController? {
    return nil
  }
}

// MARK: WorkoutSelectViewDelegate

extension WorkoutEnvironmentSetupViewController: WorkoutSelectViewDelegate {
  func nextButtonDidTap() {
    pageScrollView?.isScrollEnabled = false
    gwPageControl.next()
    pageViewController.setViewControllers([workoutPeerSelectViewController], direction: .forward, animated: true) { [weak self] _ in
      self?.pageScrollView?.isScrollEnabled = true
    }
  }
}

// MARK: UICollectionViewDelegate

extension WorkoutEnvironmentSetupViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let workoutTypesCollectionView,
          let workoutPeerTypesCollectionView
    else {
      return
    }
    // Important: The ContainerViewController has two UICollectionViews.
    // Both are controlled by the same ViewController acting as their UICollectionViewDelegate.
    // Since one ViewController is managing two UICollectionViews,
    // an if-else statement is used to differentiate between them.
    if collectionView == workoutTypesCollectionView { workoutTypesCollectionViewDidSelectItemAt(indexPath) }
    else if collectionView == workoutPeerTypesCollectionView { workoutPeerTypesCollectionViewDidSelectItemAt(indexPath) }
  }

  func workoutTypesCollectionViewDidSelectItemAt(_ indexPath: IndexPath) {
    guard
      let cell = workoutTypesCollectionView?.cellForItem(at: indexPath) as? WorkoutSelectTypeCell
    else {
      return
    }
    selectWorkoutType.send(cell.info())
  }

  func workoutPeerTypesCollectionViewDidSelectItemAt(_ indexPath: IndexPath) {
    guard
      let cell = workoutPeerTypesCollectionView?.cellForItem(at: indexPath) as? WorkoutPeerTypeSelectCell
    else {
      return
    }
    selectPeerType.send(cell.info())
  }
}
