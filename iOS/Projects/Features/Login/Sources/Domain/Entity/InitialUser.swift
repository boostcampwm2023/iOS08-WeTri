//
//  InitialUser.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - InitialUser
/// 처음 로그인 하는 유저의 Response를 담을 Entity
struct InitialUser {
  /// 처음 로그인 하는지 아닌지
  let isFirstLogined: Bool

  ///
  let mappedUserID: String

  /// OAuth 로그인 종류
  let provider: AuthProvider
}

// MARK: Codable
extension InitialUser: Codable {}

// MARK: - AuthProvider
enum AuthProvider: String, Codable {
  case apple
}
