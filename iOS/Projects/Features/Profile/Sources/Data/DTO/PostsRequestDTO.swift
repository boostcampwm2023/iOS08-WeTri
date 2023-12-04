//
//  PostsRequestDTO.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - PostsRequestDTO

struct PostsRequestDTO: Encodable {
  /// id값보다 낮은 아이템을 가져올 때 설정합니다.
  ///
  /// `idMoreThan`과 동시에 사용하면 안 됩니다.
  let idLessThan: Int?

  /// id값보다 높은 아이템을 가져올 때 설정합니다.
  ///
  /// `idMoreThan`과 동시에 사용해선 안 됩니다.
  let idMoreThan: Int?

  /// 정렬 기준입니다.
  let orderCreatedAt: Order?

  /// 가져올 아이템 수를 의미합니다.
  let limit: Int?
}

// MARK: - Order

enum Order: String, Codable {
  /// 오름차순
  case ascending = "ASC"

  /// 내림차순
  case descending = "DESC"
}
