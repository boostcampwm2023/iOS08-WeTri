//
//  MatchStartRequest.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 매칭이 시작 될 떄 사용하는 Request Body입니다.
struct MatchStartRequest: Encodable {
  /// workoutId는 운동 번호를 의미합니다.
  let workoutID: Int
}
