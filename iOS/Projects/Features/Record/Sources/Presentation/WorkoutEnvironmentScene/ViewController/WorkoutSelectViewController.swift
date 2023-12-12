//
//  WorkoutSelectViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import DesignSystem
import UIKit

// MARK: - WorkoutSelectViewDelegate

protocol WorkoutSelectViewDelegate: AnyObject {
  func nextButtonDidTap()
}

// MARK: - WorkoutSelectViewController

final class WorkoutSelectViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConstraints()
    bind()
  }

  private var subscriptions = Set<AnyCancellable>()
  weak var delegate: WorkoutSelectViewDelegate?

  private let workoutSelectDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.textAlignment = .left
    label.text = "1. 운동을 선택하세요"

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var workoutTypesCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    collectionView.register(WorkoutSelectTypeCell.self, forCellWithReuseIdentifier: WorkoutSelectTypeCell.identifier)
    collectionView.backgroundColor = UIColor.clear
    collectionView.isScrollEnabled = false

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  private let nextButton: UIButton = {
    let button = UIButton()
    button.configurationUpdateHandler = UIButton.Configuration.main(label: "다음")
    button.isEnabled = false

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
}

private extension WorkoutSelectViewController {
  func makeCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))

    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(
      top: Metrics.cellInsets,
      leading: Metrics.cellInsets,
      bottom: Metrics.cellInsets,
      trailing: Metrics.cellInsets
    )

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.55))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: section)
  }

  func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(workoutSelectDescriptionLabel)
    workoutSelectDescriptionLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    workoutSelectDescriptionLabel.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    workoutSelectDescriptionLabel.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true

    view.addSubview(workoutTypesCollectionView)
    workoutTypesCollectionView.topAnchor
      .constraint(equalTo: workoutSelectDescriptionLabel.bottomAnchor, constant: Metrics.descriptionAndWorkoutCollectionViewSpacing).isActive = true
    workoutTypesCollectionView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    workoutTypesCollectionView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    workoutTypesCollectionView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor, constant: Metrics.workoutTypeCollectionViewBottomSpacing).isActive = true

    view.addSubview(nextButton)
    nextButton.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    nextButton.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    nextButton.bottomAnchor
      .constraint(equalTo: safeArea.bottomAnchor, constant: Metrics.nextButtonAndBottomAnchorSpacing).isActive = true
    nextButton.heightAnchor.constraint(equalToConstant: Metrics.nextButtonHeight).isActive = true
  }

  func bind() {
    nextButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.delegate?.nextButtonDidTap()
      }
      .store(in: &subscriptions)
  }

  enum Metrics {
    static let cellInsets: CGFloat = 5

    static let descriptionAndWorkoutCollectionViewSpacing: CGFloat = 12

    static let workoutTypeCollectionViewBottomSpacing: CGFloat = -15

    static let nextButtonAndBottomAnchorSpacing: CGFloat = -28
    static let nextButtonHeight: CGFloat = 44
  }
}

extension WorkoutSelectViewController {
  func nextButtonEnable(_ bool: Bool) {
    nextButton.isEnabled = bool
  }
}
