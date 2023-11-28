//
//  RecordListViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 2023/11/16.
//

import Combine
import CombineCocoa
import DesignSystem
import OSLog
import UIKit

// MARK: - RecordListViewController

final class RecordListViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let appearSubject = PassthroughSubject<Void, Never>()
  private let moveWorkoutEnvironmentSceneSubject = PassthroughSubject<Void, Never>()
  let selectedDateSubject = PassthroughSubject<IndexPath, Never>()

  private let viewModel: RecordListViewModel
  private var workoutInformationDataSource: WorkoutInformationDataSource?

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

  private let goRecordButton: UIButton = {
    var configuration = UIButton.Configuration.mainEnabled(title: "기록하러가기")
    configuration.font = .preferredFont(forTextStyle: .headline, with: .traitBold)
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let noRecordsView: NoRecordsView = {
    let view = NoRecordsView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
    return view
  }()

  init(viewModel: RecordListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureUI()
    configureDataSource()
    bindViewModel()
    bindUI()
    appearSubject.send()
  }
}

// MARK: Binding

private extension RecordListViewController {
  func bindViewModel() {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()
    let input = RecordListViewModelInput(
      appear: appearSubject.eraseToAnyPublisher(),
      goRecordButtonDidTapped: moveWorkoutEnvironmentSceneSubject.eraseToAnyPublisher(),
      selectedDate: selectedDateSubject.eraseToAnyPublisher()
    )
    let output = viewModel.transform(input: input)
    output
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished:
            Logger().debug("finished")
          case let .failure(error as RecordUpdateUseCaseError) where error == .noRecord:
            self?.workoutInformationCollectionView.isHidden = true
            self?.noRecordsView.isHidden = false
            Logger().error("\(error)")
          case let .failure(error):
            Logger().error("\(error)")
          }
        },
        receiveValue: { [weak self] state in
          self?.render(output: state)
        }
      )
      .store(in: &subscriptions)
  }

  func render(output: RecordListState) {
    switch output {
    case .idle:
      break
    case let .sucessRecords(records):
      let workoutInformationItems = records.map {
        WorkoutInformationItem(sport: $0.mode.description, time: $0.timeToTime, distance: "\($0.distance)km")
      }
      configureSnapShot(items: workoutInformationItems)
      workoutInformationCollectionView.isHidden = false
      noRecordsView.isHidden = true
    case let .sucessDateInfo(dateInfo):
      guard let dayOfWeek = dateInfo.dayOfWeek else { return }
      todayLabel.text = "지금\n \(dateInfo.month)월 \(dateInfo.date)일 \(dayOfWeek)요일"
    case let .customError(error):
      Logger().error("\(error)")
    }
  }

  func bindUI() {
    goRecordButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.moveWorkoutEnvironmentSceneSubject.send()
      }
      .store(in: &subscriptions)
  }
}

// MARK: UI

private extension RecordListViewController {
  func configureUI() {
    view.addSubview(todayLabel)
    NSLayoutConstraint.activate([
      todayLabel.topAnchor.constraint(equalTo: view.topAnchor),
      todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      todayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    view.addSubview(workoutInformationCollectionView)
    NSLayoutConstraint.activate([
      workoutInformationCollectionView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: Metrics.componentInterval),
      workoutInformationCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      workoutInformationCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    view.addSubview(goRecordButton)
    NSLayoutConstraint.activate([
      goRecordButton.topAnchor.constraint(equalTo: workoutInformationCollectionView.bottomAnchor, constant: Metrics.componentInterval),
      goRecordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      goRecordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      goRecordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    view.addSubview(noRecordsView)
    NSLayoutConstraint.activate([
      noRecordsView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: Metrics.componentInterval),
      noRecordsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      noRecordsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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

    workoutInformationDataSource = WorkoutInformationDataSource(
      collectionView: workoutInformationCollectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier in
        return collectionView.dequeueConfiguredReusableCell(
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
    workoutInformationDataSource?.apply(snapShot)
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
