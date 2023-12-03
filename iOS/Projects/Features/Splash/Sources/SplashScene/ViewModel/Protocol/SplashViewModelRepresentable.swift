//
//  SplashViewModelRepresentable.swift
//  SplashFeature
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
