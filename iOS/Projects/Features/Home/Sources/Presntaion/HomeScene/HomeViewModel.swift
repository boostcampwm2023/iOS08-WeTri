//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - HomeViewModelInput

public struct HomeViewModelInput {}

public typealias HomeViewModelOutput = AnyPublisher<HomeState, Never>

// MARK: - HomeState

public enum HomeState {
  case idle
}

// MARK: - HomeViewModelRepresentable

protocol HomeViewModelRepresentable {
  func transform(input: HomeViewModelInput) -> HomeViewModelOutput
}

// MARK: - HomeViewModel

final class HomeViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: HomeViewModelRepresentable

extension HomeViewModel: HomeViewModelRepresentable {
  public func transform(input _: HomeViewModelInput) -> HomeViewModelOutput {
    subscriptions.removeAll()

    let initialState: HomeViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
