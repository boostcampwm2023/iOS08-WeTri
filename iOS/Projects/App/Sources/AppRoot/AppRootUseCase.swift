//
//  AppRootUseCase.swift
//  WeTri
//
//  Created by 홍승현 on 11/15/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import WeTriArchitecture

// MARK: - AppRootCoordinating

protocol AppRootCoordinating: Coordinating {
  func attachTabs()
}

// MARK: - AppRootPresentable

protocol AppRootPresentable: AnyObject {
  var listener: AppRootPresentableListener? { get set }
}

// MARK: - AppRootListener

protocol AppRootListener: AnyObject {}

// MARK: - AppRootUseCase

final class AppRootUseCase: UseCase<AppRootPresentable>, AppRootUseCaseRepresentable, AppRootPresentableListener {
  weak var coordinator: AppRootCoordinating?
  weak var listener: AppRootListener?

  init(presenter: AppRootPresentable) {
    super.init(viewModel: presenter)
    presenter.listener = self
  }

  override private init(viewModel: AppRootPresentable) {
    super.init(viewModel: viewModel)
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    print(#function)

    coordinator?.attachTabs()
  }
}
