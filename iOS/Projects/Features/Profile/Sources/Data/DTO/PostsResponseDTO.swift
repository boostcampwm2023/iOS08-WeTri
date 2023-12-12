//
//  PostsResponseDTO.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - PostsResponseDTO

public struct PostsResponseDTO: Codable {
  /// 게시글 목록
  let posts: [Post]

  /// 받아온 게시글의 메타데이터
  let metaData: PagingMetaData

  enum CodingKeys: String, CodingKey {
    case posts = "items"
    case metaData
  }
}

// MARK: - Post

/// 게시글
public struct Post: Codable, Hashable {
  /// 게시글 Identifier
  let id: Int

  /// 게시글 내용
  let content: String

  /// 게시글 이미지 URL
  let postURL: URL

  enum CodingKeys: String, CodingKey {
    case id
    case content
    case postURL = "postUrl"
  }
}

// MARK: - PagingMetaData

struct PagingMetaData: Codable {
  /// 받아온 데이터 중 제일 마지막의 ID값
  ///
  /// 다음에 요청으로 보낼 id값입니다.
  let lastID: Int?

  /// 받아온 데이터 개수
  let count: Int

  /// 마지막 커서 여부
  let isLastCursor: Bool

  enum CodingKeys: String, CodingKey {
    case lastID = "lastItemId"
    case isLastCursor
    case count
  }
}
