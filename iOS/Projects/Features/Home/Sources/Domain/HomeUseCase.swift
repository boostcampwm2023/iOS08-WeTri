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
  func fetchFeed() -> AnyPublisher<[FeedElement], Never>
}

// MARK: - HomeUseCase

public struct HomeUseCase: HomeUseCaseRepresentable {
  let feedRepositoryRepresentable: FeedRepositoryRepresentable
  var latestFeedPage = 0

  var pipeLine: PassthroughSubject<Int, Never> = .init()
  let checkManager: FetchCheckManager = .init()

  init(feedRepositoryRepresentable: FeedRepositoryRepresentable) {
    self.feedRepositoryRepresentable = feedRepositoryRepresentable
  }

  public func fetchFeed() -> AnyPublisher<[FeedElement], Never> {
    if checkManager[latestFeedPage] == false {
      return Empty().eraseToAnyPublisher()
    }
    checkManager[latestFeedPage] = true
    return feedRepositoryRepresentable.fetchFeed(at: latestFeedPage)
  }
}

// MARK: - FetchCheckManager

final class FetchCheckManager {
  subscript(page: Int) -> Bool {
    get {
      return check(at: page)
    }
    set {
      set(at: page)
    }
  }

  private var requestedFetchPageNumber: [Int: Bool] = [:]
  /// FetchCheckManager를 통해서 특정 페이지에 대해 요청을 했다고 저장합니다.
  private func set(at page: Int) {
    requestedFetchPageNumber[page] = true
  }

  /// FetchCheckManager를 통해서, 특정 페이지에 대한 과거 요청에 대해서 살펴 봅니다.
  ///
  /// 만약 요청한 적이 없다면 false를, 요청을 했다면 true를 리턴
  private func check(at page: Int) -> Bool {
    return requestedFetchPageNumber[page] ?? false
  }
}
