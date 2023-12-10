//
//  SettingsViewController.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

// MARK: - SettingsViewController

final class SettingsViewController: UICollectionViewController {
  // MARK: Properties

  private let viewModel: SettingsViewModelRepresentable

  private let profileSettings: PassthroughSubject<Void, Never> = .init()
  private let logoutSubject: PassthroughSubject<Void, Never> = .init()

  private var dataSource: SettingsDataSource?

  private let logger = Log.make()
  private var subscriptions: Set<AnyCancellable> = []

  // MARK: Initializations

  deinit {
    logger.debug("\(Self.self) deinitialized")
  }

  init(viewModel: SettingsViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped)))
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
  }

  // MARK: Configuration

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.tintColor = DesignSystemColor.primaryText
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.backButtonDisplayMode = .minimal
    navigationItem.title = "설정"
  }

  private func bind() {
    viewModel.transform(
      input: .init(
        profileSettingsPublisher: profileSettings.eraseToAnyPublisher(),
        logoutPublisher: logoutSubject.eraseToAnyPublisher()
      )
    )
    .sink { [weak self] state in
      switch state {
      case .idle:
        break
      case let .alert(message):
        self?.showAlert(with: message)
      }
    }
    .store(in: &subscriptions)
  }

  // MARK: - Custom Methods

  /// 에러 알림 문구를 보여줍니다.
  private func showAlert(with value: Any) {
    let alertController = UIAlertController(title: "알림", message: String(describing: value), preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "확인", style: .default))
    present(alertController, animated: true)
  }
}

// MARK: - Diffable DataSource Settings

private extension SettingsViewController {
  typealias SettingsDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias SettingsSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
  typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
  enum Section {
    case main
  }

  enum Item: String, CaseIterable {
    case profileSetting = "프로필 설정"
    case contact = "문의하기"
    case logout = "로그아웃"
    case signOut = "회원탈퇴"
  }

  private func setupDataSource() {
    let registration = ListCellRegistration { cell, _, itemIdentifier in
      var configuration = cell.defaultContentConfiguration()
      configuration.text = itemIdentifier.rawValue
      cell.contentConfiguration = configuration
    }

    let dataSource = SettingsDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
    }

    self.dataSource = dataSource
  }

  private func setupInitialSnapshots() {
    guard let dataSource else { return }
    var snapshot = SettingsSnapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems([.profileSetting, .contact, .logout, .signOut], toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension SettingsViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)

    // 배열 out of index 방어
    guard Item.allCases.indices ~= indexPath.item else {
      return
    }

    switch Item.allCases[indexPath.item] {
    case .profileSetting:
      profileSettings.send(())
    case .logout:
      logoutSubject.send(())
    default:
      break
    }
  }
}
