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

  private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()

  private let viewModel: ProfileSettingsViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private var dataSource: ProfileSettingsDataSource?

  private var headerViewData: Profile?

  // MARK: Initializations

  init(viewModel: ProfileSettingsViewModelRepresentable) {
    self.viewModel = viewModel

    let layout = UICollectionViewCompositionalLayout { sectionNumber, environment in
      // Section을 위한 리스트 configuration 생성
      var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
      if sectionNumber == Section.header.rawValue {
        configuration.headerMode = .supplementary
      }

      // Header를 위한 Supplementary Item 등록
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
      let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )

      // Section에 header 추가
      let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
      if sectionNumber == Section.header.rawValue {
        section.boundarySupplementaryItems = [header]
      }

      return section
    }

    super.init(collectionViewLayout: layout)
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
    setupDataSource()
    setupInitialSnapshots()
    viewDidLoadSubject.send(())
  }

  // MARK: Configuration

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    collectionView.backgroundColor = DesignSystemColor.primaryBackground
  }

  private func bind() {
    viewModel.transform(input: .init(viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher()))
      .sink { [weak self] state in
        self?.render(state: state)
      }
      .store(in: &subscriptions)
  }

  private func render(state: ProfileSettingsState) {
    switch state {
    case .idle:
      break
    case let .alert(error):
      showAlert(message: error.localizedDescription)
    case let .profile(profile):
      headerViewData = profile
      updateProfileHeaders()
    }
  }

  private func showAlert(
    title: String = "알림",
    message: String,
    showCancel: Bool = false,
    okActionHandler: ((UIAlertAction) -> Void)? = nil
  ) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(.init(title: "확인", style: .default, handler: okActionHandler))
    if showCancel {
      alertController.addAction(.init(title: "취소", style: .cancel))
    }
    present(alertController, animated: true)
  }
}

private extension ProfileSettingsViewController {
  typealias ProfileSettingsDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias ProfileSettingsSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
  typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<ProfileSettingsHeaderView>

  enum Section: Int {
    case header
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

    let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, _, _ in
      headerView.configure(with: self?.headerViewData)
    }

    let dataSource = ProfileSettingsDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
    }

    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      // Header view 요청을 확인합니다.
      if kind == UICollectionView.elementKindSectionHeader {
        return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
      }
      return nil
    }

    self.dataSource = dataSource
  }

  private func setupInitialSnapshots() {
    guard let dataSource else { return }
    var snapshot = ProfileSettingsSnapshot()
    snapshot.appendSections([.header, .main])
    snapshot.appendItems(Item.allCases, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  private func updateProfileHeaders() {
    guard let dataSource else { return }

    var snapshot = dataSource.snapshot()
    snapshot.reloadSections([.header])
  }
}

extension ProfileSettingsViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}
