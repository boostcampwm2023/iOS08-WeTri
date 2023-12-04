//
//  PostsResponseDTO.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - PostsResponseDTO

struct PostsResponseDTO: Codable {
  /// 게시글 목록
  let posts: [Post]

  /// 받아온 게시글의 메타데이터
  let metaData: MetaData

  enum CodingKeys: String, CodingKey {
    case posts = "items"
    case metaData
  }
}

// MARK: - Post

/// 게시글
public struct Post: Codable {
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

// MARK: - MetaData

struct MetaData: Codable {
  /// 다음에 요청으로 보낼 id값
  let nextID: Int

  /// 받아온 데이터 개수
  let count: Int

  enum CodingKeys: String, CodingKey {
    case nextID = "after"
    case count
  }
}
