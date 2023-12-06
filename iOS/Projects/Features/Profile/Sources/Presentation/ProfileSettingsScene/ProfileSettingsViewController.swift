//
//  ProfileSettingsViewController.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - ProfileSettingsViewController

final class ProfileSettingsViewController: UICollectionViewController {
  // MARK: Properties

  private let viewModel: ProfileSettingsViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private var dataSource: ProfileSettingsDataSource?

  // MARK: Initializations

  init(viewModel: ProfileSettingsViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setupStyles()
    bind()
  }

  // MARK: Configuration

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  private func bind() {
    let output = viewModel.transform(input: .init())
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }
}

private extension ProfileSettingsViewController {
  typealias ProfileSettingsDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias ProfileSettingsSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
  enum Section {
    case main
  }

  enum Item: String, CaseIterable {
    case nicknameSetting = "닉네임 설정"
    case photoSetting = "프로필 사진 설정"
  }

  private func setupDataSource() {
    let registration = ListCellRegistration { cell, _, itemIdentifier in
      var configuration = cell.defaultContentConfiguration()
      configuration.text = itemIdentifier.rawValue
      cell.contentConfiguration = configuration
    }

    let dataSource = ProfileSettingsDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
    }

    self.dataSource = dataSource
  }

  private func setupInitialSnapshots() {
    guard let dataSource else { return }
    var snapshot = ProfileSettingsSnapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(Item.allCases, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
