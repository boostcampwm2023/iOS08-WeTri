//
//  WorkoutHistorySelectViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

// MARK: - WorkoutHistorySelectViewController

final class WorkoutHistorySelectViewController: UIViewController {
  // MARK: Properties

  private let viewModel: SelectWorkoutViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private lazy var workoutHistoryCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
    collectionView.register(WorkoutHistoryCell.self, forCellWithReuseIdentifier: WorkoutHistoryCell.identifier)
    collectionView.delegate = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  // MARK: Initializations

  init(viewModel: SelectWorkoutViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  deinit {
    Log.make().debug("\(Self.self) did be deinit")
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

private extension WorkoutHistorySelectViewController {
  func setup() {
    setupStyles()
    setupNavigationItem()
    setupHierarchyAndConstraints()
    bind()
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func setupNavigationItem() {
    navigationItem.title = "운동을 선택하세요"
  }

  func bind() {
    let output = viewModel.transform(input: .init())
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  enum Metrics {}
}

// MARK: UICollectionViewDelegate

extension WorkoutHistorySelectViewController: UICollectionViewDelegate {}

private extension WorkoutHistorySelectViewController {
  func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )

    let group = NSCollectionLayoutGroup(
      layoutSize: .init(
        widthDimension: .fractionalHeight(1),
        heightDimension: .fractionalHeight(1 / 9)
      )
    )

    let section = NSCollectionLayoutSection(group: group)

    return .init(section: section)
  }
}
