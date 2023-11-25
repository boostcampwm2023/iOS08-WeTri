//
//  WorkoutPeerSelectViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/19/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import DesignSystem
import UIKit

// MARK: - WorkoutPeerSelectViewController

final class WorkoutPeerSelectViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = DesignSystemColor.primaryBackground

    setup()
  }

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
    button.isEnabled = false

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var pearTypeSelectCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    collectionView.register(WorkoutPeerTypeSelectCell.self, forCellWithReuseIdentifier: WorkoutPeerTypeSelectCell.identifier)
    collectionView.backgroundColor = .clear
    collectionView.isScrollEnabled = false

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
}

private extension WorkoutPeerSelectViewController {
  func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    item.contentInsets = .init(top: Metrics.itemInsets, leading: Metrics.itemInsets, bottom: Metrics.itemInsets, trailing: Metrics.itemInsets)

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

    view.addSubview(pearTypeSelectCollectionView)
    pearTypeSelectCollectionView.topAnchor
      .constraint(equalTo: workoutSelectDescriptionLabel.bottomAnchor, constant: 15).isActive = true
    pearTypeSelectCollectionView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.secondaryValue).isActive = true
    pearTypeSelectCollectionView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.secondaryValue).isActive = true
    pearTypeSelectCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    view.addSubview(startButton)
    startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50).isActive = true
    startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    startButton.widthAnchor.constraint(equalToConstant: Metrics.buttonHeight).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight).isActive = true
  }

  enum Metrics {
    static let buttonHeight: CGFloat = 150
    static let buttonWidth: CGFloat = 150

    static let itemInsets: CGFloat = 9
  }
}

extension WorkoutPeerSelectViewController {
  func startButtonEnable(_ bool: Bool) {
    startButton.isEnabled = bool
  }

  func startButtonDidTapPublisher() -> AnyPublisher<Void, Never> {
    return startButton
      .publisher(.touchUpInside)
      .map { _ in () }
      .eraseToAnyPublisher()
  }
}
