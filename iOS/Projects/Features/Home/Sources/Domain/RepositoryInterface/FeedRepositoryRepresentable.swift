//
//  FeedRepositoryRepresentable.swift
//  HomeFeature
//
//  Created by MaraMincho on 1/2/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - FeedRepositoryRepresentable

public protocol FeedRepositoryRepresentable {
  func fetchFeed(at page: Int) -> AnyPublisher<[FeedElement], Never>
}
