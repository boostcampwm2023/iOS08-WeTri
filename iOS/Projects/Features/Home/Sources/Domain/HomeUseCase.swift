//
//  HomeUseCase.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - HomeUseCaseRepresentable

public protocol HomeUseCaseRepresentable {
  func fetchFeed(at page: Int) -> AnyPublisher<[FeedElement], Never>
}

// MARK: - HomeUseCase

public struct HomeUseCase: HomeUseCaseRepresentable {
  let feedRepositoryRepresentable: FeedRepositoryRepresentable
  init(feedRepositoryRepresentable: FeedRepositoryRepresentable) {
    self.feedRepositoryRepresentable = feedRepositoryRepresentable
  }

  public func fetchFeed(at page: Int) -> AnyPublisher<[FeedElement], Never> {
    return feedRepositoryRepresentable.fetchFeed(at: page)
  }
}
