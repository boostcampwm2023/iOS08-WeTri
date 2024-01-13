//
//  FeedElement.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct FeedElement: Hashable, Codable {
  /// 개시물의 아이디 입니다.
  let ID: Int

  /// 게시물을 올린 유저의 고유 식별자 입니다.
  let publicID: String

  /// 게시물을 올린 유저의 닉네임 입니다.
  let nickName: String

  /// 언제 게시물을 발행했는지에 대한 정보 입니다.
  let publishDate: Date

  /// 게시물 올린 유저의 프로피 이미지 입니다.
  let profileImage: URL?

  /// 어떤 운동을 했는지에 관한 값 입니다.
  let sportText: String

  /// 게시물의 내용 입니다.
  let content: String

  /// 게시물 관련 이미지에 관한 값 입니다.
  let postImages: [URL?]

  /// 좋아요 갯수 입니다.
  let like: Int
}
