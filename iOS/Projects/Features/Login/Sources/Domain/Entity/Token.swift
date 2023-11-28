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
struct Token {
  /// accessToken
  let accesToken: Data

  /// refreshToken
  let refreshToken: Data

  init(accesToken: Data = Data(count: 0), refreshToken: Data = Data(count: 0)) {
    self.accesToken = accesToken
    self.refreshToken = refreshToken
  }
}

// MARK: Codable

extension Token: Codable {}