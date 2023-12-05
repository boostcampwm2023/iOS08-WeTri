// 
//  HomeViewController.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

final class HomeViewController: UIViewController {

  // MARK: Properties

  private let viewModel: HomeViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let button: UIButton = .init(configuration: .mainEnabled(title: "test button"))

  // MARK: Initializations

  init(viewModel: HomeViewModelRepresentable) {
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

private extension HomeViewController {
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
