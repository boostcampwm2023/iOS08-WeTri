//
//  ProfileRepository.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Trinet

// MARK: - ProfileRepository

public struct ProfileRepository: ProfileRepositoryRepresentable {
  private let provider: TNProvider<ProfileEndPoint>

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }
}

// MARK: - ProfileEndPoint

private enum ProfileEndPoint {
  case fetchProfile
  case fetchPosts
}

// MARK: TNEndPoint

extension ProfileEndPoint: TNEndPoint {
  var path: String {
    ""
  }

  var method: TNMethod {
    .get
  }

  var query: Encodable? {
    nil
  }

  var body: Encodable? {
    nil
  }

  var headers: TNHeaders {
    []
  }
}
