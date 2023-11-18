//
//  RecordContainerViewController.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/18.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - RecordContainerViewController

public final class RecordContainerViewController: UIViewController {
  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

private extension RecordContainerViewController {
  func configureUI() {
    let safeArea = view.safeAreaLayoutGuide

    let recordListViewController = RecordListViewController()
    guard let recordView = recordListViewController.view else { return }
    recordView.translatesAutoresizingMaskIntoConstraints = false
    add(child: recordListViewController)
    NSLayoutConstraint.activate([
      recordView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      recordView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      recordView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      recordView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    ])
  }

  func add(child viewController: UIViewController) {
    addChild(viewController)
    view.addSubview(viewController.view)
    viewController.didMove(toParent: viewController)
  }
}
