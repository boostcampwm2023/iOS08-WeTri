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

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: SplashViewModelRepresentable

extension SplashViewModel: SplashViewModelRepresentable {
  public func transform(input: SplashViewModelInput) -> SplashViewModelOutput {
    subscriptions.removeAll()

    input.viewDidLoadPublisher

    let initialState: SplashViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
