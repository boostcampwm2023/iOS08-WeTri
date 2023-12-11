//
//  Profile.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct Profile {
  /// 프로필 이미지 데이터
  let profileData: Data

  /// 프로필 닉네임
  let nickname: String

  /// 사용자의 생년월일
  let birth: String?

  init(profileData: Data, nickname: String, birth: String? = nil) {
    self.profileData = profileData
    self.nickname = nickname
    self.birth = birth
  }
}
