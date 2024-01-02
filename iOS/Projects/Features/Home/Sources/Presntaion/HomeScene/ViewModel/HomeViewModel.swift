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

public struct HomeViewModelInput {
  let requestFeedPublisher: AnyPublisher<Void, Never>
}

public typealias HomeViewModelOutput = AnyPublisher<HomeState, Never>

// MARK: - HomeState

public enum HomeState {
  case idle
  case fetched(feed: [FeedElement])
}

// MARK: - HomeViewModelRepresentable

protocol HomeViewModelRepresentable {
  func transform(input: HomeViewModelInput) -> HomeViewModelOutput
}

// MARK: - HomeViewModel

final class HomeViewModel {
  // MARK: - Properties

  private let useCase: HomeUseCaseRepresentable
  private var subscriptions: Set<AnyCancellable> = []
  var tempID: Int = 0
  init(useCase: HomeUseCaseRepresentable) {
    self.useCase = useCase
  }
}

// MARK: HomeViewModelRepresentable

extension HomeViewModel: HomeViewModelRepresentable {
  public func transform(input: HomeViewModelInput) -> HomeViewModelOutput {
    subscriptions.removeAll()

    let fetched: HomeViewModelOutput = input.requestFeedPublisher
      .flatMap { [useCase] _ in
        useCase.fetchFeed()
      }
      .map { feed in
        return HomeState.fetched(feed: feed)
      }
      .eraseToAnyPublisher()

    let initialState: HomeViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: fetched)
      .eraseToAnyPublisher()
  }
}
