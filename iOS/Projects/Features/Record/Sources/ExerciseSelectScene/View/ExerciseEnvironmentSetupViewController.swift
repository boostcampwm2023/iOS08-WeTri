//
//  ExerciseEnvironmentSetupViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - ExerciseEnvironmentSetupViewController

public final class ExerciseEnvironmentSetupViewController: UIViewController {
  override public func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    insertTempSource()
  }

  lazy var contentNAV: UINavigationController = {
    let nav = UINavigationController(rootViewController: exerciseSelectView)

    return nav
  }()

  private let exerciseSelectView = ExerciseSelectViewController()

  private let pageControl: GWPageControl = {
    let pageControl = GWPageControl(count: Constant.countOfPage)

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()

  var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
  var exerciseCardCollectionView: UICollectionView!
}

private extension ExerciseEnvironmentSetupViewController {
  func setup() {
    view.backgroundColor = .systemBackground
    setupViewHierarchyAndConstraints()
    exerciseCardCollectionView = exerciseSelectView.exerciseCardCollectionView

    configureDataSource()
  }

  func configureDataSource() {
    dataSource = .init(collectionView: exerciseCardCollectionView, cellProvider: { collectionView, indexPath, _ in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCardCell.identifier, for: indexPath)
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

    view.addSubview(contentNAV.view)
    contentNAV.view.translatesAutoresizingMaskIntoConstraints = false
    contentNAV.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    contentNAV.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    contentNAV.view.topAnchor.constraint(equalTo: pageControl.bottomAnchor).isActive = true
    contentNAV.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }

  enum Constant {
    static let countOfPage = 2
  }
}
