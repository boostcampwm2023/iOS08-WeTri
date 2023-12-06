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
  private var hasFetchedForRequestID: Set<Int?> = []
  private let repository: ProfileRepositoryRepresentable

  // MARK: Initializations

  public init(repository: ProfileRepositoryRepresentable) {
    self.repository = repository
  }

  /// 처음부터 새롭게 가져오기 위해 데이터를 리셋합니다.
  private func resetDataForNewFetch() {
    nextRequestID = nil
    isLast = false
    hasFetchedForRequestID.removeAll()
  }

  /// 게시물을 가져올 수 있는지 확인합니다.
  private func shouldFetchPosts(lastItem: ProfileItem?) -> Bool {
    return nextRequestID != lastItem?.id && hasFetchedForRequestID.contains(lastItem?.id) == false
  }

  /// 가져온 메타데이터를 이용해서 UseCase가 관리하는 pagination 프로퍼티를 설정합니다.
  private func updateFetchStatus(from metaData: MetaData) {
    nextRequestID = metaData.lastID
    isLast = metaData.isLastCursor
  }

  /// 요청할 requestID를 캐시에 저장하고, repository에게 ID를 동봉하여 게시글을 요청합니다.
  private func fetchAndProcessPosts() -> AnyPublisher<[Post], Error> {
    hasFetchedForRequestID.insert(nextRequestID)

    return repository.fetchPosts(nextID: nextRequestID)
      .map { [weak self] in
        self?.updateFetchStatus(from: $0.metaData)
        return $0.posts
      }
      .eraseToAnyPublisher()
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
      resetDataForNewFetch()
      return fetchAndProcessPosts()
    }

    // 보내준 item의 id값이 동일해야하고, 주어진 커서ID로 이미 로딩된 경우
    guard shouldFetchPosts(lastItem: lastItem) else {
      return Empty<[Post], Error>().eraseToAnyPublisher()
    }

    return fetchAndProcessPosts()
  }
}
