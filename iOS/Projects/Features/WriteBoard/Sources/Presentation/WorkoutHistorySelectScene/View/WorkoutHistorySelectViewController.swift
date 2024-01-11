//
//  WorkoutHistorySelectViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

// MARK: - WorkoutHistorySelectViewController

final class WorkoutHistorySelectViewController: UIViewController {
  // MARK: Properties

  private let viewModel: SelectWorkoutViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private var dataSource: UITableViewDiffableDataSource<Int, Record>? = nil

  // MARK: UI Components

  private lazy var workoutHistoryTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.register(WorkoutHistoryCell.self, forCellReuseIdentifier: WorkoutHistoryCell.identifier)
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.delegate = self

    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  // MARK: Initializations

  init(viewModel: SelectWorkoutViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  deinit {
    Log.make().debug("\(Self.self) did be deinit")
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

private extension WorkoutHistorySelectViewController {
  func setup() {
    setDataSource()
    setupStyles()
    setupNavigationItem()
    setupHierarchyAndConstraints()
    bind()
    setFakeData()
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(workoutHistoryTableView)
    workoutHistoryTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    workoutHistoryTableView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor).isActive = true
    workoutHistoryTableView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor).isActive = true
    workoutHistoryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }

  func setDataSource() {
    dataSource = .init(tableView: workoutHistoryTableView) { tableView, _, itemIdentifier in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutHistoryCell.identifier) as? WorkoutHistoryCell else {
        return UITableViewCell()
      }
      cell.configure(itemIdentifier)
      return cell
    }
    guard let dataSource else { return }

    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0])
    dataSource.apply(snapshot)
  }

  func setFakeData() {
    guard let dataSource else {
      return
    }
    var snapshot = dataSource.snapshot()
    snapshot.appendItems([
      .init(dateString: "11월 9일", workoutID: 2, startTime: "06:00", endTime: "06:30", distance: 500),
      .init(dateString: "11월 7일", workoutID: 1, startTime: "06:00", endTime: "07:00", distance: 1500),
      .init(dateString: "11월 6일", workoutID: 3, startTime: "06:00", endTime: "06:30", distance: 1000),
    ])
    dataSource.apply(snapshot)
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func setupNavigationItem() {
    navigationItem.title = "운동을 선택하세요"
  }

  func bind() {
    let output = viewModel.transform(input: .init())
    output.sink { state in
      switch state {
      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }

  enum Metrics {}
}

// MARK: UITableViewDelegate

extension WorkoutHistorySelectViewController: UITableViewDelegate {
  func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
    return 80
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = dataSource?.snapshot().itemIdentifiers[indexPath.row]
    
  }
}
