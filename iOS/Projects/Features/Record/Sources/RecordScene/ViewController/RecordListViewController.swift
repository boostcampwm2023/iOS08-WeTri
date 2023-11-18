//
//  RecordListViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 2023/11/16.
//

import DesignSystem
import UIKit

// MARK: - RecordListViewController

public final class RecordListViewController: UIViewController {
  private var workoutInforamtionDataSource: WorkoutInformationDataSource?

  private let todayLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "오늘\n ??월 ??일 ?요일"
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .title1, with: .traitBold)
    return label
  }()

  private lazy var workoutInformationCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 6
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.delegate = self
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()

  private let recordButton: UIButton = {
    var configuration = UIButton.Configuration.mainEnabled(title: "기록하러가기")
    configuration.font = .preferredFont(forTextStyle: .headline, with: .traitBold)
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureUI()
    configureDataSource()
    // ViewModel 생성 전, 앱이 돌아가는지 확인하기 위한 간단한 예제
    let items: [WorkoutInformationItem] = [
      .init(sport: "수영", time: "08:00~09:00", distance: "12.12Km"),
      .init(sport: "수영", time: "08:00~09:00", distance: "12.12Km"),
      .init(sport: "수영", time: "08:00~09:00", distance: "12.12Km"),
      .init(sport: "수영", time: "08:00~09:00", distance: "12.12Km"),
      .init(sport: "수영", time: "08:00~09:00", distance: "12.12Km"),
    ]
    configureSnapShot(items: items)
  }
}

// MARK: UI

private extension RecordListViewController {
  func configureUI() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(todayLabel)
    NSLayoutConstraint.activate([
      todayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.topInterval),
      todayLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.componentInterval),
      todayLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.componentInterval),
    ])

    view.addSubview(workoutInformationCollectionView)
    NSLayoutConstraint.activate([
      workoutInformationCollectionView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: Metrics.componentInterval),
      workoutInformationCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.componentInterval),
      workoutInformationCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.componentInterval),
    ])

    view.addSubview(recordButton)
    NSLayoutConstraint.activate([
      recordButton.topAnchor.constraint(equalTo: workoutInformationCollectionView.bottomAnchor, constant: Metrics.componentInterval),
      recordButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.componentInterval),
      recordButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.componentInterval),
      recordButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.bottomInterval),
    ])
  }

  func configureDataSource() {
    let cellRegistration = WorkoutInformationCellRegistration { cell, _, item in
      cell.configure(workoutInformation:
        WorkoutInformation(
          sport: item.sport,
          time: item.time,
          distance: item.distance
        )
      )
    }

    workoutInforamtionDataSource = WorkoutInformationDataSource(
      collectionView: workoutInformationCollectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier in

        collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: itemIdentifier
        )
      }
    )
  }

  func configureSnapShot(items: [WorkoutInformationItem]) {
    var snapShot = WorkoutInformationSnapShot()
    snapShot.appendSections([.workoutList])
    snapShot.appendItems(items)
    workoutInforamtionDataSource?.apply(snapShot)
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension RecordListViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt _: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width / Metrics.itemWidthRatio, height: workoutInformationCollectionView.frame.height / Metrics.itemHeightRatio)
  }
}

// MARK: - Metrics

private enum Metrics {
  static let componentInterval: CGFloat = 24
  static let topInterval: CGFloat = 92
  static let bottomInterval: CGFloat = 215
  static let itemWidthRatio: CGFloat = 2.45
  static let itemHeightRatio: CGFloat = 1.5
}

// MARK: RecordViewController DiffableDataSource

private extension RecordListViewController {
  typealias WorkoutInformationCellRegistration = UICollectionView.CellRegistration<WorkoutInformationCollectionViewCell, WorkoutInformationItem>
  typealias WorkoutInformationDataSource = UICollectionViewDiffableDataSource<Section, WorkoutInformationItem>
  typealias WorkoutInformationSnapShot = NSDiffableDataSourceSnapshot<Section, WorkoutInformationItem>
}

// MARK: - Section

private enum Section {
  case workoutList
}

// MARK: - WorkoutInformationItem

private struct WorkoutInformationItem: Identifiable, Hashable {
  let id = UUID()
  let sport: String
  let time: String
  let distance: String
}
