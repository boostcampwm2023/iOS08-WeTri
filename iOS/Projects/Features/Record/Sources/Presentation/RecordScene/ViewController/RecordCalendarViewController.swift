//
//  RecordCalendarViewController.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/18.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import OSLog
import UIKit

// MARK: - RecordCalendarViewController

final class RecordCalendarViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let viewModel: RecordCalendarViewModel
  private var dataSource: RecordCalendarDiffableDataSource?

  private let appearSubject = PassthroughSubject<Void, Never>()
  private let selectedDateSubject = PassthroughSubject<IndexPath, Never>()
  private let cellReuseSubject = PassthroughSubject<Void, Never>()

  var selectedDatePublisher: AnyPublisher<IndexPath, Never> {
    selectedDateSubject.eraseToAnyPublisher()
  }

  init(viewModel: RecordCalendarViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

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
    bindViewModel()
    appearSubject.send()
  }
}

private extension RecordCalendarViewController {
  func bindViewModel() {
    subscriptions.forEach {
      $0.cancel()
    }
    subscriptions.removeAll()
    let input = RecordCalendarViewModelInput(
      appear: appearSubject.eraseToAnyPublisher(),
      calendarDateDidTapped: selectedDateSubject.eraseToAnyPublisher(),
      calendarCellReuse: cellReuseSubject.eraseToAnyPublisher()
    )
    let output = viewModel.transform(input: input)
    output.sink { completion in
      switch completion {
      case .finished: break
      case let .failure(error):
        Logger().debug("\(error)")
      }
    } receiveValue: { [weak self] state in
      self?.render(output: state)
    }
    .store(in: &subscriptions)
  }

  func render(output: RecordCalendarState) {
    switch output {
    case let .date(dateInfos):
      let calendarInformationItems = dateInfos.map { dateInfo in
        return CalendarInforamtionItem(dayOfWeek: dateInfo.dayOfWeek!, date: dateInfo.date)
      }
      configureSnapshot(items: calendarInformationItems)
    case let .indexPath(indexPath):
      Logger().debug("output : \(indexPath.item)")
      guard let cell = calendarCollectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else {
        return
      }
      cell.configureTextColor(isSelected: true)
    }
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
      cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
        self?.cellReuseSubject.send()
        return collectionView.dequeueConfiguredReusableCell(
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
    Logger().debug("선택 : \(indexPath.item)")
    selectedDateSubject.send(indexPath)
    cell.configureTextColor(isSelected: true)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didDeselectItemAt indexPath: IndexPath
  ) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else {
      return
    }
    Logger().debug("선택해제 : \(indexPath.item)")
    cell.configureTextColor(isSelected: false)
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
