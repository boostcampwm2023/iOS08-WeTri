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
public struct InitialUser {
  /// 처음 로그인 하는지 아닌지
  public let isFirstLogined: Bool

  ///
  public let mappedUserID: String

  /// OAuth 로그인 종류
  public let provider: AuthProvider

  public init(
    isFirstLogined: Bool,
    mappedUserID: String,
    provider: AuthProvider
  ) {
    self.isFirstLogined = isFirstLogined
    self.mappedUserID = mappedUserID
    self.provider = provider
  }
}

// MARK: Codable

extension InitialUser: Codable {}

// MARK: - AuthProvider

public enum AuthProvider: String, Codable {
  case apple
}
