//
//  Tokens.swift
//  CommonNetworkingKeyManager
//
//  Created by MaraMincho on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// AccessToken과 Refresh토큰에 관한 KeyChain에 Key의 관한 값을 다음과 같이 쓰면 됩니다.
///
public enum Tokens {
  public static let accessToken = "AccessToken"
  public static let refreshToken = "RefreshToken"
}
