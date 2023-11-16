//
//  ExerciseSelectViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - ExerciseSelectViewController

final class ExerciseSelectViewController: UIViewController {
  override init(nibName _: String?, bundle _: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupConstraints()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private let exerciseSelectDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1, with: .traitBold)
    label.textAlignment = .left
    label.text = "1. 운동을 선택하세요"

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var exerciseCardCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    collectionView.register(ExerciseCardCell.self, forCellWithReuseIdentifier: ExerciseCardCell.identifier)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  private let nextButton: UIButton = {
    let button = UIButton()
    button.configurationUpdateHandler = UIButton.Configuration.main(label: "다음")

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
}

private extension ExerciseSelectViewController {
  func makeCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))

    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(
      top: Const.CellInset,
      leading: Const.CellInset,
      bottom: Const.CellInset,
      trailing: Const.CellInset
    )

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalWidth(0.55))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: section)
  }

  func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(exerciseSelectDescriptionLabel)
    exerciseSelectDescriptionLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    exerciseSelectDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    exerciseSelectDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true

    view.addSubview(exerciseCardCollectionView)
    exerciseCardCollectionView.topAnchor.constraint(equalTo: exerciseSelectDescriptionLabel.bottomAnchor, constant: 12).isActive = true
    exerciseCardCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    exerciseCardCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    exerciseCardCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true

    view.addSubview(nextButton)
    nextButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    nextButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    nextButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -28).isActive = true
  }

  enum Const {
    static let CellInset: CGFloat = 5
  }
}
