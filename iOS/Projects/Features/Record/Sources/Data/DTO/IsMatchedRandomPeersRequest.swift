//
//  IsMatchedRandomPeersRequest.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// randomMatching API의 requst에 활용합니다.
///
/// 어떤 운동과, 얼마나 randomMatching을 기다렸는지 알려주는 객체 입니다.
struct IsMatchedRandomPeersRequest: Encodable {
  /// 어떤 운동을 랜덤 매칭 하는지 알려줍니다.
  ///
  /// 1번 : 달리기
  /// 2번 : 사이클
  /// 3번 : 수영
  let workoutID: Int

  /// 몇초를 대기방에서 기다렸는지 알려줍니다.
  let waitingTime: Int
}
