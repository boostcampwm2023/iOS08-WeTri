//
//  ProfileDTO.swift
//  SplashFeature
//
//  Created by MaraMincho on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - ProfileDTO

/// 프로필 정보를 갖습니다.
public struct ProfileDTO: Decodable {
  /// 닉네임
  let nickname: String

  /// 성별
  ///
  /// `남자`, `여자`로 반환됩니다.
  let gender: String

  /// 생일
  let birthdate: Date

  /// 프로필 이미지
  let profileImage: URL

  /// 사용자의 퍼블릭 아이디 입니다.
  let publicID: String
}
