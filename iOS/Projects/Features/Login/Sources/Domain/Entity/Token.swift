//
//  Token.swift
//  LoginFeature
//
//  Created by 안종표 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 백엔드로부터 받아온 JWT를 담을 데이터 entity
public struct Token {
  /// accessToken
  let accesToken: Data

  /// refreshToken
  let refreshToken: Data
}
