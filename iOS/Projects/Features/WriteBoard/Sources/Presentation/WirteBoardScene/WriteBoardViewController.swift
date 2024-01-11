//
//  WriteBoardViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WriteBoardViewController

final class WriteBoardViewController: UIViewController {
  // MARK: Properties

  private let viewModel: WriteBoardViewModelRepresentable

  private let completeButtonDidTapPublisher: PassthroughSubject<Void, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Component

  private lazy var completeBarButtonItem: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonDidTap))

    return button
  }()

  // MARK: Initializations

  init(viewModel: WriteBoardViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
}

private extension WriteBoardViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
    setupNavigationItem()
  }

  func setupNavigationItem() {
    navigationItem.backButtonTitle = "뒤로"
    navigationItem.title = "글쓰기"

    navigationItem.rightBarButtonItem = completeBarButtonItem
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
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

  @objc
  func completeButtonDidTap() {
    completeButtonDidTapPublisher.send()
  }

  enum Metrics {}
}
