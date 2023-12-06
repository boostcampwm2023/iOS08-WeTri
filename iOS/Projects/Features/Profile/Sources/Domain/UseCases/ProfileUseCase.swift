//
//  ProfileUseCase.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - ProfileUseCase

public final class ProfileUseCase {
  // MARK: Properties

  /// 다음에 요청할 커서 id
  private var nextRequestID: Int?

  /// 마지막 데이터를 가져왔는가
  private var isLast: Bool = false

  /// 요청한 커서 id로 데이터를 가져왔는지 확인하기 위한 캐싱 변수
  private var isFetchedByCacheID: [Int?: Bool] = [nil: true]
  private let repository: ProfileRepositoryRepresentable

  // MARK: Initializations

  public init(repository: ProfileRepositoryRepresentable) {
    self.repository = repository
  }
}

// MARK: ProfileUseCaseRepresentable

extension ProfileUseCase: ProfileUseCaseRepresentable {
  public func fetchProfile() -> AnyPublisher<Profile, Error> {
    return repository.fetchProfiles()
  }

  public func fetchPosts(lastItem: ProfileItem?, refresh: Bool) -> AnyPublisher<[Post], Error> {
    // 이미 마지막 데이터를 요청했던 경우
    if isLast {
      return Empty<[Post], Error>().eraseToAnyPublisher()
    }

    // 다시 새롭게 데이터를 가져오는 경우
    if refresh {
      isFetchedByCacheID = [nil: true]
      nextRequestID = nil
      return repository.fetchPosts(nextID: nextRequestID)
        .map { [weak self] in
          self?.nextRequestID = $0.metaData.lastID
          return $0.posts
        }
        .eraseToAnyPublisher()
    }

    // 보내준 item의 id값이 동일해야하고, 주어진 커서ID로 이미 로딩된 경우
    guard
      nextRequestID == lastItem?.id,
      isFetchedByCacheID[nextRequestID, default: false] == false
    else {
      return Empty<[Post], Error>().eraseToAnyPublisher()
    }

    isFetchedByCacheID[nextRequestID] = true

    return repository.fetchPosts(nextID: nextRequestID)
      .map { [weak self] in
        self?.nextRequestID = $0.metaData.lastID
        return $0.posts
      }
      .eraseToAnyPublisher()
  }
}
