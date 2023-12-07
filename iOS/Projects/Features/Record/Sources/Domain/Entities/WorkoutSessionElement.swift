//
//  WorkoutSessionElement.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// RandomMatching에서 WorkoutSession으로 화면전환 할 때 넘겨주는 데이터 입니다.
struct WorkoutSessionElement {
  let startDate: Date
  let peers: [Peer]
  let roomID: String

  private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
    return formatter
  }()

  /// 스트링으로 데이터를 받았을 때 서버에서 내려준 값이
  /// 현재 시간보다 과거거나, 서버에서 내려준 시간이 잘못되었을 경우
  /// 현재시간 + 4 초 후에 운동을 시작하는 것으로 세팅했습니다.
  init(startDateString: String, peers: [Peer], roomID: String) {
    var date = formatter.date(from: startDateString) ?? .now + 4
    if Date.now > date {
      date = Date.now + 4
    }
    startDate = date
    self.peers = peers
    self.roomID = roomID
  }

  init(startDate: Date, peers: [Peer], roomID: String) {
    self.startDate = startDate
    self.peers = peers
    self.roomID = roomID
  }
}
