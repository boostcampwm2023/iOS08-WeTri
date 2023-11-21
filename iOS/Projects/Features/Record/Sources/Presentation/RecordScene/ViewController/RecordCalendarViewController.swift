//
//  RecordCalendarViewController.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/18.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - RecordCalendarViewController

final class RecordCalendarViewController: UIViewController {
  private var dataSource: RecordCalendarDiffableDataSource?
  private lazy var calendarCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.delegate = self
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureDataSource()
    let items = [
      CalendarInforamtionItem(dayOfWeek: "화", date: "17"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "18"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "19"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "20"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
      CalendarInforamtionItem(dayOfWeek: "화", date: "21"),
    ]
    configureSnapshot(items: items)
  }
}

private extension RecordCalendarViewController {
  func configureUI() {
    view.addSubview(calendarCollectionView)
    NSLayoutConstraint.activate([
      calendarCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
      calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      calendarCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  func configureDataSource() {
    let cellRegistration = RecordCalendarCellRegistration { cell, _, itemIdentifier in
      cell.configure(
        calendarInformation: CalendarInforamtion(
          dayOfWeek: itemIdentifier.dayOfWeek,
          date: itemIdentifier.date
        )
      )
    }

    dataSource = RecordCalendarDiffableDataSource(
      collectionView: calendarCollectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier in
        collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: itemIdentifier
        )
      }
    )
  }

  func configureSnapshot(items: [CalendarInforamtionItem]) {
    var snapShot = RecordCalendarSnapShot()
    snapShot.appendSections([.calendar])
    snapShot.appendItems(items)
    dataSource?.apply(snapShot)
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension RecordCalendarViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt _: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width / 7.5, height: collectionView.frame.height)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else {
      return
    }
    cell.dayOfWeekLabel.textColor = DesignSystemColor.primaryText
    cell.dateLabel.textColor = DesignSystemColor.primaryText
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didDeselectItemAt indexPath: IndexPath
  ) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else {
      return
    }
    cell.dayOfWeekLabel.textColor = DesignSystemColor.gray03
    cell.dateLabel.textColor = DesignSystemColor.gray03
  }
}

private extension RecordCalendarViewController {
  typealias RecordCalendarCellRegistration = UICollectionView.CellRegistration<CalendarCollectionViewCell, CalendarInforamtionItem>
  typealias RecordCalendarDiffableDataSource = UICollectionViewDiffableDataSource<Section, CalendarInforamtionItem>
  typealias RecordCalendarSnapShot = NSDiffableDataSourceSnapshot<Section, CalendarInforamtionItem>
}

// MARK: - Section

private enum Section {
  case calendar
}

// MARK: - CalendarInforamtionItem

private struct CalendarInforamtionItem: Identifiable, Hashable {
  let id = UUID()
  let dayOfWeek: String
  let date: String
}
