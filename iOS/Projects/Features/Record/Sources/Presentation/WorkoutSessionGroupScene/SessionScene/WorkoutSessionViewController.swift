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
  var healthDataPublisher: AnyPublisher<WorkoutHealthForm, Never> { get }
}

// MARK: - WorkoutSessionViewControllerDependency

protocol WorkoutSessionViewControllerDependency {
  var participants: [SessionPeerType] { get }
}

// MARK: - WorkoutSessionViewController

public final class WorkoutSessionViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutSessionViewModelRepresentable

  private var participantsDataSource: ParticipantsDataSource?

  @Published private var healthData: WorkoutHealthForm = .init(
    distance: nil,
    calorie: nil,
    averageHeartRate: nil,
    minimumHeartRate: nil,
    maximumHeartRate: nil
  )

  private var realTimeModelByID: [UserID: WorkoutHealthRealTimeModel] = [:]
  private var userInfoByID: [UserID: SessionPeerType] = [:]

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

  init(viewModel: WorkoutSessionViewModelRepresentable, dependency: WorkoutSessionViewControllerDependency) {
    self.viewModel = viewModel
    for participant in dependency.participants {
      Log.make().debug("사람 id는 \(participant.id), nickName: \(participant.nickname)")
      userInfoByID[participant.id] = participant
      realTimeModelByID[participant.id] = .init(distance: 0, calories: 0, heartRate: 0)
    }

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
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .idle:
          break
        case .alert:
          break
        case let .fetchMyHealthForm(myHealthForm):
          self?.healthData = myHealthForm
        case let .fetchParticipantsIncludedMySelf(model):
          Log.make().debug("\(model)")
          self?.realTimeModelByID[model.id] = model.health
          var snapshot = self?.participantsDataSource?.snapshot()

          snapshot?.reconfigureItems([model.id])
          if let snapshot {
            let temp = snapshot.itemIdentifiers
            Log.make().debug("현재 snpahot의 아이템은 다음과 같습니다. \(temp)")
            self?.participantsDataSource?.apply(snapshot)
          } else {
            Log.make().error("snapshot이 생성되지 못했습니다. 헬스 데이터로 UI를 그리지 못합니다.")
          }
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
    let cellRegistration = ParticipantsCellRegistration { [weak self] cell, _, itemIdentifier in
      cell.configure(initial: self?.userInfoByID[itemIdentifier] ?? .init(nickname: "Unknown", id: "Unknown", profileImageURL: .init(filePath: "")))
      cell.configure(with: self?.realTimeModelByID[itemIdentifier])
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
    snapshot.appendItems(Array(userInfoByID.keys))

    participantsDataSource.apply(snapshot)
  }

  private func updateSnapshot(from identifier: String) {
    guard let participantsDataSource else { return }
    var snapshot = participantsDataSource.snapshot()
    snapshot.reconfigureItems([identifier])
    participantsDataSource.apply(snapshot)
  }
}

// MARK: HealthDataProtocol

extension WorkoutSessionViewController: HealthDataProtocol {
  var healthDataPublisher: AnyPublisher<WorkoutHealthForm, Never> {
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
  typealias UserID = String

  typealias Item = UserID

  enum Section {
    case main
  }
}
