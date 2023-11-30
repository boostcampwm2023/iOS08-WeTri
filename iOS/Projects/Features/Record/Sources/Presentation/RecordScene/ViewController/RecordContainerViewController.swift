//
//  RecordContainerViewController.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/18.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import UIKit

// MARK: - RecordContainerViewController

public final class RecordContainerViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let recordCalendarViewController: RecordCalendarViewController
  private let recordListViewController: RecordListViewController

  init(recordCalendarViewController: RecordCalendarViewController, recordListViewController: RecordListViewController) {
    self.recordCalendarViewController = recordCalendarViewController
    self.recordListViewController = recordListViewController
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindRecordCalendarViewController()
  }
}

private extension RecordContainerViewController {
  func bindRecordCalendarViewController() {
    recordCalendarViewController.selectedDatePublisher
      .sink { [weak self] indexPath in
        self?.recordListViewController.selectedDateSubject.send(indexPath)
      }
      .store(in: &subscriptions)
  }
}

private extension RecordContainerViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.isHidden = true
    let safeArea = view.safeAreaLayoutGuide

    guard let calendarView = recordCalendarViewController.view else { return }
    calendarView.translatesAutoresizingMaskIntoConstraints = false
    add(child: recordCalendarViewController)
    NSLayoutConstraint.activate([
      calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.componentInterval),
      calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.componentInterval),
      calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.componentInterval),
      calendarView.heightAnchor.constraint(equalToConstant: Metrics.calendarHeight),
    ])

    guard let listView = recordListViewController.view else { return }
    listView.translatesAutoresizingMaskIntoConstraints = false
    add(child: recordListViewController)
    NSLayoutConstraint.activate([
      listView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: Metrics.componentInterval),
      listView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.componentInterval),
      listView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.componentInterval),
      listView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.bottomInterval),
    ])
  }

  func add(child viewController: UIViewController) {
    addChild(viewController)
    view.addSubview(viewController.view)
    viewController.didMove(toParent: viewController)
  }
}

// MARK: - Metrics

private enum Metrics {
  static let componentInterval: CGFloat = 24
  static let bottomInterval: CGFloat = 215
  static let calendarHeight: CGFloat = 51
}
