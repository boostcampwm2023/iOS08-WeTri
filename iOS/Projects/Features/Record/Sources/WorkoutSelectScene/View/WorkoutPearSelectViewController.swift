//
//  WorkoutPearSelectViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/19/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - WorkoutPearSelectViewController

final class WorkoutPearSelectViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = DesignSystemColor.primaryBackGround

    setup()

    dataSource = .init(collectionView: pearTypeSelectCollectionView, cellProvider: { collectionView, indexPath, _ in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkoutPearTypeSelectCell.identifier, for: indexPath)

      return cell
    })
    tempInitDataSource()
  }

  var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!

  private let workoutSelectDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1, with: .traitBold)
    label.textAlignment = .left

    label.text = "2. 누구랑 할까요?"

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let startButton: UIButton = {
    let button = UIButton()
    button.configurationUpdateHandler = UIButton.Configuration.mainCircular(label: "출발")

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var pearTypeSelectCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    collectionView.register(WorkoutPearTypeSelectCell.self, forCellWithReuseIdentifier: WorkoutPearTypeSelectCell.identifier)
    collectionView.backgroundColor = .clear

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
}

private extension WorkoutPearSelectViewController {
  func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    item.contentInsets = .init(top: Materics.itemInsets, leading: Materics.itemInsets, bottom: Materics.itemInsets, trailing: Materics.itemInsets)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: section)
  }

  func setup() {
    setHierarchyAndConstraints()
  }

  func setHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(workoutSelectDescriptionLabel)
    workoutSelectDescriptionLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    workoutSelectDescriptionLabel.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    workoutSelectDescriptionLabel.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true

    view.addSubview(startButton)
    startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50).isActive = true
    startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    startButton.widthAnchor.constraint(equalToConstant: Materics.buttonHeight).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: Materics.buttonHeight).isActive = true

    view.addSubview(pearTypeSelectCollectionView)
    pearTypeSelectCollectionView.topAnchor
      .constraint(equalTo: workoutSelectDescriptionLabel.bottomAnchor, constant: 15).isActive = true
    pearTypeSelectCollectionView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.secondaryValue).isActive = true
    pearTypeSelectCollectionView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.secondaryValue).isActive = true
    pearTypeSelectCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  func tempInitDataSource() {
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems([.init(), .init(), .init()])
    dataSource.apply(snapshot)
  }

  enum Materics {
    static let buttonHeight: CGFloat = 150
    static let buttonWidth: CGFloat = 150

    static let itemInsets: CGFloat = 9
  }
}