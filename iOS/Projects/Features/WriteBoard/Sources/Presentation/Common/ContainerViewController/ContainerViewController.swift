// 
//  ContainerViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

final class ContainerViewController: UINavigationController {

  // MARK: Properties

  private let viewModel: ContainerViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let button: UIButton = .init(configuration: .mainEnabled(title: "test button"))

  // MARK: Initializations

  init(viewModel: ContainerViewModelRepresentable) {
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

private extension ContainerViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
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
  
  enum Metrics {
    
  }
}
