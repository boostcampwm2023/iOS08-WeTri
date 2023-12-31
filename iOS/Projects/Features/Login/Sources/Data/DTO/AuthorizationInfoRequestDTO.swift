//
//  AuthorizationInfoRequestDTO.swift
//  LoginFeature
//
//  Created by 안종표 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 애플로그인을 통해 받아온 데이터 entity
struct AuthorizationInfoRequestDTO: Codable {
  /// identityToken
  let identityToken: String

  /// authorizationCode
  let authorizationCode: String
}
