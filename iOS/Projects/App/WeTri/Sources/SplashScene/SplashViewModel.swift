//
//  SplashViewModel.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - SplashViewModelInput

public struct SplashViewModelInput {
  let viewDidLoadPublisher: AnyPublisher<Void, Never>
}

public typealias SplashViewModelOutput = AnyPublisher<SplashState, Never>

// MARK: - SplashState

public enum SplashState {
  case idle
}

// MARK: - SplashViewModelRepresentable

public protocol SplashViewModelRepresentable {
  func transform(input: SplashViewModelInput) -> SplashViewModelOutput
}

// MARK: - SplashViewModel

public final class SplashViewModel {
  // MARK: Properties

  private weak var coordinator: SplashCoordinating?
  private var subscriptions: Set<AnyCancellable> = []
  private let useCase: SplashUseCaseRepresentable

  // MARK: Initializations

  public init(
    coordinator: SplashCoordinator,
    useCase: SplashUseCaseRepresentable
  ) {
    self.coordinator = coordinator
    self.useCase = useCase
  }
}

// MARK: SplashViewModelRepresentable

extension SplashViewModel: SplashViewModelRepresentable {
  public func transform(input: SplashViewModelInput) -> SplashViewModelOutput {
    subscriptions.removeAll()

    input.viewDidLoadPublisher
      .flatMap(useCase.reissueToken)
      .sink { [weak self] hasTokenReissued in
        self?.coordinator?.showLoginOrMainFlow(when: hasTokenReissued)
      }
      .store(in: &subscriptions)

    let initialState: SplashViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
