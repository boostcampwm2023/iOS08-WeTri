//
//  NewUserInformation.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Foundation

// MARK: - NewUserInformation

/// 처음 로그인 하는 유저의 Response를 담을 Entity
public struct NewUserInformation {
  /// 애플 토큰에 있는 유저정보인데 보안때문에 UUID로 매핑한 ID
  public let mappedUserID: String

  /// OAuth 로그인 종류
  public let provider: AuthProvider

  public init(mappedUserID: String, provider: AuthProvider) {
    self.mappedUserID = mappedUserID
    self.provider = provider
  }
}

// MARK: Codable

extension NewUserInformation: Codable {}
