//
//  WorkoutEnvironmentSetupViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import OSLog
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

  var cancellables = Set<AnyCancellable>()
  var viewModel: WorkoutEnvironmentSetupViewModelRepresentable?

  // MARK: - WorkoutEnvironmentSetupViewModelInput

  let requestWorkoutTypes = PassthroughSubject<Void, Never>()
  let requestWorkoutPeerTypes = PassthroughSubject<Void, Never>()
  let selectWorkoutType = PassthroughSubject<WorkoutType?, Never>()
  let selectPeerType = PassthroughSubject<PeerType?, Never>()
  let endWorkoutEnvironment = PassthroughSubject<Void, Never>()

  // MARK: - ConatinerViewController Control Property

  var workoutTypesDataSource: UICollectionViewDiffableDataSource<Int, WorkoutType>?
  var workoutPeerTypesDataSource: UICollectionViewDiffableDataSource<Int, PeerType>?

  var workoutTypesCollectionView: UICollectionView?
  var workoutPeerTypesCollectionView: UICollectionView?

  private let workoutSelectViewController = WorkoutSelectViewController()
  private let workoutPeerSelectViewController = WorkoutPeerSelectViewController()

  private let pageControl: GWPageControl = {
    let pageControl = GWPageControl(count: Constant.countOfPage)

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()

  lazy var contentNavigationController = UINavigationController()
}

private extension WorkoutEnvironmentSetupViewController {
  func setup() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    setupViewHierarchyAndConstraints()
    addNavigationGesture()
    bind()

    configureDataSource()
  }

  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(pageControl)
    pageControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
    pageControl.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value + 11).isActive = true
    pageControl.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

    view.addSubview(contentNavigationController.view)
    contentNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
    contentNavigationController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentNavigationController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    contentNavigationController.view.topAnchor.constraint(equalTo: pageControl.bottomAnchor).isActive = true
    contentNavigationController.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }

  func addNavigationGesture() {
    guard let recognizer = contentNavigationController.interactivePopGestureRecognizer else { return }
    recognizer.delegate = self
    recognizer.isEnabled = true
    contentNavigationController.delegate = self
  }

  func bind() {
    workoutTypesCollectionView = workoutSelectViewController.workoutTypesCollectionView
    workoutTypesCollectionView?.delegate = self

    workoutPeerTypesCollectionView = workoutPeerSelectViewController.pearTypeSelectCollectionView
    workoutPeerTypesCollectionView?.delegate = self

    workoutSelectViewController.delegate = self

    bindViewModel()
  }

  func bindViewModel() {
    guard let viewModel else { return }
    cancellables.removeAll()

    let input = WorkoutEnvironmentSetupViewModelInput(
      requestWorkoutTypes: requestWorkoutTypes.eraseToAnyPublisher(),
      requestWorkoutPeerTypes: requestWorkoutPeerTypes.eraseToAnyPublisher(),
      endWorkoutEnvironment: endWorkoutEnvironment.eraseToAnyPublisher(),
      selectWorkoutType: selectWorkoutType.eraseToAnyPublisher(),
      selectPeerType: selectPeerType.eraseToAnyPublisher()
    )

    let output = viewModel.transform(input: input)

    output
      .sink { [weak self] state in
        guard let self else { return }
        switch state {
        // TODO: failure에 알맞는 로직 세우기
        case .error,
             .idle: break
        case let .workoutTpyes(workoutTypes): updateWorkout(types: workoutTypes)
        case let .workoutPeerTypes(peer): updateWorkoutPeer(types: peer)
        case let .didSelectWorkoutType(bool): workoutSelectViewController.nextButtonEnable(bool)
        case let .didSelectWorkoutPeerType(bool): workoutPeerSelectViewController.startButtonEnable(bool)
        }
      }
      .store(in: &cancellables)
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
        description: item.workoutIconDescription,
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
    snapshot.appendItems(types)

    DispatchQueue.main.async {
      workoutPeerTypesDataSource.apply(snapshot)
    }
  }

  func updateWorkout(types: [WorkoutType]) {
    guard let workoutTypesDataSource else { return }
    var snapshot = workoutTypesDataSource.snapshot()
    snapshot.deleteAllItems()
    snapshot.appendSections([0])
    snapshot.appendItems(types)

    DispatchQueue.main.async {
      workoutTypesDataSource.apply(snapshot)
    }
  }
}

// MARK: UIGestureRecognizerDelegate

extension WorkoutEnvironmentSetupViewController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
    return contentNavigationController.viewControllers.count > 1
  }
}

// MARK: UINavigationControllerDelegate

extension WorkoutEnvironmentSetupViewController: UINavigationControllerDelegate {
  public func navigationController(_: UINavigationController, didShow viewController: UIViewController, animated _: Bool) {
    if viewController == workoutSelectViewController {
      pageControl.select(at: 0)
    }
  }
}

// MARK: WorkoutSelectViewDelegate

extension WorkoutEnvironmentSetupViewController: WorkoutSelectViewDelegate {
  func nextButtonDidTap() {
    pageControl.next()
    contentNavigationController.pushViewController(workoutPeerSelectViewController, animated: true)
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
      let cell = workoutTypesCollectionView?.dequeueReusableCell(withReuseIdentifier: WorkoutSelectTypeCell.identifier, for: indexPath)
      as? WorkoutSelectTypeCell
    else {
      return
    }
    selectWorkoutType.send(cell.info())
  }

  func workoutPeerTypesCollectionViewDidSelectItemAt(_ indexPath: IndexPath) {
    guard
      let cell = workoutPeerTypesCollectionView?.dequeueReusableCell(withReuseIdentifier: WorkoutPeerTypeSelectCell.identifier, for: indexPath)
      as? WorkoutPeerTypeSelectCell
    else {
      return
    }
    selectPeerType.send(cell.info())
  }
}
