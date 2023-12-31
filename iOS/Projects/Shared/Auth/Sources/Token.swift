//
//  Token.swift
//  LoginFeature
//
//  Created by 안종표 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - Token

/// 백엔드로부터 받아온 JWT를 담을 데이터 entity
public struct Token {
  /// accessToken
  public let accessToken: String?

  /// refreshToken
  public let refreshToken: String?

  public init(accesToken: String? = nil, refreshToken: String? = nil) {
    accessToken = accesToken
    self.refreshToken = refreshToken
  }
}

// MARK: Codable

extension Token: Codable {}
