//
//  WorkoutSessionViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

// MARK: - HealthDataProtocol

/// 건강 정보를 제공받을 때 사용합니다.
protocol HealthDataProtocol: UIViewController {
  /// 건강 데이터를 제공하는 Publisher
  var healthDataPublisher: AnyPublisher<WorkoutHealth, Never> { get }
}

// MARK: - WorkoutSessionViewController

public final class WorkoutSessionViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutSessionViewModelRepresentable

  private var participantsDataSource: ParticipantsDataSource?

  @Published private var healthData: WorkoutHealth = .init(
    distance: nil,
    calorie: nil,
    averageHeartRate: nil,
    minimumHeartRate: nil,
    maximumHeartRate: nil
  )

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private lazy var participantsCollectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: createCompositionalLayout()
    )
    collectionView.backgroundColor = DesignSystemColor.primaryBackground
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()

  // MARK: Initializations

  public init(viewModel: WorkoutSessionViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    Log.make().debug("\(Self.self) deinitialized")
  }

  // MARK: Life Cycles

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
    generateDataSources()
    setupInitialSnapshots()
  }

  // MARK: Configuration

  private func setupLayouts() {
    view.addSubview(participantsCollectionView)
  }

  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    participantsCollectionView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        participantsCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
        participantsCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
        participantsCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        participantsCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      ]
    )
  }

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

  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(Metrics.collectionViewCellHeight)
      )
    )
    item.edgeSpacing = .init(
      leading: nil,
      top: .fixed(Metrics.collectionViewItemSpacing),
      trailing: nil,
      bottom: .fixed(Metrics.collectionViewItemSpacing)
    )

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(468) // Item 높이와 수에 따라 정해지기에 의미없는 값(468)을 넣음
      ),
      subitems: [item]
    )

    let section = NSCollectionLayoutSection(group: group)

    return UICollectionViewCompositionalLayout(section: section)
  }

  /// DataSource를 생성합니다.
  private func generateDataSources() {
    let cellRegistration = ParticipantsCellRegistration { cell, _, itemIdentifier in
      cell.configure(with: itemIdentifier)
    }

    participantsDataSource = ParticipantsDataSource(
      collectionView: participantsCollectionView
    ) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
    }
  }

  private func setupInitialSnapshots() {
    guard let participantsDataSource else { return }
    var snapshot = ParticipantsSnapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(
      [
        "house",
        "square.and.arrow.up",
        "pencil.circle",
        "pencil.and.outline",
        "pencil.tip.crop.circle.badge.minus.fill",
      ]
    )

    participantsDataSource.apply(snapshot)
  }
}

// MARK: HealthDataProtocol

extension WorkoutSessionViewController: HealthDataProtocol {
  var healthDataPublisher: AnyPublisher<WorkoutHealth, Never> {
    $healthData.eraseToAnyPublisher()
  }
}

// MARK: WorkoutSessionViewController.Metrics

private extension WorkoutSessionViewController {
  enum Metrics {
    static let collectionViewItemSpacing: CGFloat = 6
    static let collectionViewCellHeight: CGFloat = 84
  }
}

// MARK: - Diffable DataSources Options

private extension WorkoutSessionViewController {
  typealias ParticipantsCellRegistration = UICollectionView.CellRegistration<SessionParticipantCell, Item>
  typealias ParticipantsDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias ParticipantsSnapshot = NSDiffableDataSourceSnapshot<Section, Item>

  // TODO: API가 정해진 뒤 Item 설정 필요
  typealias Item = String

  enum Section {
    case main
  }
}
