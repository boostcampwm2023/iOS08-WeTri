//
//  DateRequestDTO.swift
//  RecordFeature
//
//  Created by 안종표 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - DateRequestDTO

/// 기록을 가져오기 위해 Date를 year, month, day로 변환해서 서버로 request 요청할 때 사용하는 DTO
struct DateRequestDTO {
  /// 연도
  let year: Int

  /// 월
  let month: Int

  /// 일
  let day: Int
}

// MARK: Codable

extension DateRequestDTO: Codable {}
