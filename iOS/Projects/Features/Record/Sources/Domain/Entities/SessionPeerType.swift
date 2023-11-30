//
//  SessionPeerType.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 운동 세션 중 사용자의 UI 정보를 업데이트 하기 위해 사용합니다.
struct SessionPeerType: Identifiable {
  /// 사용자 닉네임
  let nickname: String

  /// 사용자의 Identifier
  let id: String

  /// 사용자의 프로필 이미지 주소
  let profileImageURL: URL
}
