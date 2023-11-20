//
//  WorkoutEnvironmentSetupViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import OSLog
import UIKit

// MARK: - WorkoutEnvironmentSetupViewController

public final class WorkoutEnvironmentSetupViewController: UIViewController {
  override public func viewDidLoad() {
    super.viewDidLoad()
    setup()
    insertTempSource()
  }

  lazy var contentNavigationController: UINavigationController = {
    let nav = UINavigationController(rootViewController: workoutSelectViewController)

    return nav
  }()

  private let workoutSelectViewController = WorkoutSelectViewController()
  private let workoutPeerSelectViewController = WorkoutPeerSelectViewController()

  private let pageControl: GWPageControl = {
    let pageControl = GWPageControl(count: Constant.countOfPage)

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()

  var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
  var workoutTypesCollectionView: UICollectionView!
  var workoutPaerTypesCollectionView: UICollectionView!
}

private extension WorkoutEnvironmentSetupViewController {
  func bind() {
    workoutTypesCollectionView = workoutSelectViewController.workoutTypesCollectionView

    workoutSelectViewController.delegate = self
  }

  func setup() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    setupViewHierarchyAndConstraints()
    addNavigationGesture()
    bind()

    configureDataSource()
  }

  func configureDataSource() {
    dataSource = .init(collectionView: workoutTypesCollectionView, cellProvider: { collectionView, indexPath, _ in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutSelectTypeCell.identifier, for: indexPath)
      return cell
    })
  }

  func insertTempSource() {
    var snapshot = dataSource.snapshot()
    snapshot.deleteAllItems()
    snapshot.appendSections([0])
    snapshot.appendItems([.init(), .init(), .init(), .init(), .init()])

    dataSource.apply(snapshot)
  }

  func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(pageControl)
    pageControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
    pageControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 23).isActive = true
    pageControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -23).isActive = true
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

  enum Constant {
    static let countOfPage = 2
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
