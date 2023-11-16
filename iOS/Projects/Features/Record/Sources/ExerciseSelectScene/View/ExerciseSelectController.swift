//
//  ExerciseSelectController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - ExerciseSelectController

public class ExerciseSelectController: UIViewController {
  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    setup()
    configureDataSource()
    insertTempSource()
  }

  private let pageControl: GWPageControl = {
    let pageControl = GWPageControl(count: 5)

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()

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

  var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
}

private extension ExerciseSelectController {
  func setup() {
    view.backgroundColor = .systemBackground
    setupConstraints()
  }

  func makeCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))

    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalWidth(0.6))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: section)
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

  func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(pageControl)
    pageControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
    pageControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 23).isActive = true
    pageControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -23).isActive = true
    pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

    view.addSubview(exerciseSelectDescriptionLabel)
    exerciseSelectDescriptionLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12).isActive = true
    exerciseSelectDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 23).isActive = true
    exerciseSelectDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -23).isActive = true

    view.addSubview(exerciseCardCollectionView)
    exerciseCardCollectionView.topAnchor.constraint(equalTo: exerciseSelectDescriptionLabel.bottomAnchor, constant: 15).isActive = true
    exerciseCardCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 23).isActive = true
    exerciseCardCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -23).isActive = true
    exerciseCardCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true

    view.addSubview(nextButton)
    nextButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 23).isActive = true
    nextButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -23).isActive = true
    nextButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -28).isActive = true
  }
}
