//
//  WorkoutSummaryViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WorkoutSummaryViewController

public final class WorkoutSummaryViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WorkoutSummaryViewModelRepresentable

  private var participantsDataSource: ParticipantsDataSource?

  private var subscriptions: Set<AnyCancellable> = []

  private let endWorkoutSubject: PassthroughSubject<Void, Never> = .init()

  // MARK: UI Components

  private let recordTimerLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.text = "0분 0초"
    return label
  }()

  private lazy var endWorkoutButton: UIButton = {
    let button = UIButton(configuration: .mainCircularEnabled(title: "종료"))
    button.configuration?.font = .preferredFont(forTextStyle: .largeTitle, with: .traitBold)
    button.accessibilityHint = "운동을 종료합니다."
    button.addAction(
      UIAction { [weak self] _ in
        self?.endWorkoutSubject.send(())
      },
      for: .touchUpInside
    )
    return button
  }()

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

  public init(viewModel: WorkoutSummaryViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    view.addSubview(recordTimerLabel)
    view.addSubview(participantsCollectionView)
    view.addSubview(endWorkoutButton)
  }

  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    recordTimerLabel.translatesAutoresizingMaskIntoConstraints = false
    endWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
    participantsCollectionView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        recordTimerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        recordTimerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
        recordTimerLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.recordTimerLabelTop),

        participantsCollectionView.topAnchor.constraint(
          equalTo: recordTimerLabel.bottomAnchor,
          constant: Metrics.collectionViewTop
        ),
        participantsCollectionView.leadingAnchor.constraint(
          equalTo: safeArea.leadingAnchor,
          constant: Metrics.horizontal
        ),
        participantsCollectionView.trailingAnchor.constraint(
          equalTo: safeArea.trailingAnchor,
          constant: -Metrics.horizontal
        ),
        participantsCollectionView.bottomAnchor.constraint(
          equalTo: endWorkoutButton.topAnchor,
          constant: -Metrics.collectionViewBottom
        ),

        endWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        endWorkoutButton.widthAnchor.constraint(equalToConstant: Metrics.endingWorkoutButtonSize),
        endWorkoutButton.heightAnchor.constraint(equalToConstant: Metrics.endingWorkoutButtonSize),
        endWorkoutButton.bottomAnchor.constraint(
          equalTo: safeArea.bottomAnchor,
          constant: -Metrics.endingWorkoutButtonBottom
        ),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  private func bind() {
    let output = viewModel.transform(input: .init(endWorkoutPublisher: endWorkoutSubject.eraseToAnyPublisher()))
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

// MARK: WorkoutSummaryViewController.Metrics

private extension WorkoutSummaryViewController {
  enum Metrics {
    static let recordTimerLabelTop: CGFloat = 12
    static let collectionViewTop: CGFloat = 12
    static let collectionViewBottom: CGFloat = 44
    static let collectionViewItemSpacing: CGFloat = 6
    static let horizontal: CGFloat = 36
    static let endingWorkoutButtonBottom: CGFloat = 32

    static let endingWorkoutButtonSize: CGFloat = 150
    static let collectionViewCellHeight: CGFloat = 84
  }
}

// MARK: - Diffable DataSources Options

private extension WorkoutSummaryViewController {
  typealias ParticipantsCellRegistration = UICollectionView.CellRegistration<ParticipantsCollectionViewCell, Item>
  typealias ParticipantsDataSource = UICollectionViewDiffableDataSource<Section, Item>
  typealias ParticipantsSnapshot = NSDiffableDataSourceSnapshot<Section, Item>

  // TODO: API가 정해진 뒤 Item 설정 필요
  typealias Item = String

  enum Section {
    case main
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
#Preview {
  WorkoutSummaryViewController(viewModel: WorkoutSummaryViewModel())
}
