//
//  AuthorizationInfo.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - AuthorizationInfo

/// 애플로그인을 통해 받아온 데이터 entity
public struct AuthorizationInfo {
  /// identityToken
  let identityToken: Data

  /// authorizationCode
  let authorizationCode: Data
}
