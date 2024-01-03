//
//  FeedRepository.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Trinet

// MARK: - FeedRepository

public struct FeedRepository: FeedRepositoryRepresentable {
  let decoder = JSONDecoder()
  let provider: TNProvider<FeedEndPoint>

  init(session: URLSessionProtocol = URLSession.shared) {
    provider = .init(session: session)
  }

  public func fetchFeed(at page: Int) -> AnyPublisher<[FeedElement], Never> {
    return Future<[FeedElement], Error> { promise in
      Task {
        do {
          let data = try await provider.request(.fetchPosts(page: page), interceptor: TNKeychainInterceptor.shared)
          let feedElementList = try decoder.decode([FeedElement].self, from: data)
          promise(.success(feedElementList))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .catch { _ in return Empty() }
    .eraseToAnyPublisher()
  }

  public func refreshFeed() -> AnyPublisher<[FeedElement], Never> {
    return Future<[FeedElement], Error> { promise in
      Task { [provider] in
        do {
          let data = try await provider.request(.refreshFeed, interceptor: TNKeychainInterceptor.shared)
          let feedElementList = try decoder.decode([FeedElement].self, from: data)
          promise(.success(feedElementList))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .catch { _ in return Empty() }
    .eraseToAnyPublisher()
  }
}

// MARK: - FeedEndPoint

public enum FeedEndPoint: TNEndPoint {
  case fetchPosts(page: Int)
  case refreshFeed

  public var path: String {
    return ""
  }

  public var method: TNMethod {
    return .post
  }

  public var query: Encodable? {
    return nil
  }

  public var body: Encodable? {
    switch self {
    case let .fetchPosts(page):
      return page
    case .refreshFeed:
      return nil
    }
  }

  public var headers: TNHeaders {
    return .default
  }
}
