//
//  WorkoutSessionElement.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct WorkoutSessionElement {
  let startDate: Date
  let peers: [Peer]
  let roomID: String

  private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
    return formatter
  }()

  /// 고민점 서버에서 만약 시간을 잘못 내려준다면, 3초 카운트 다운 타이머를 시작하도록 하였음
  init(startDateString: String, peers: [Peer], roomID: String) {
    let date = formatter.date(from: startDateString)
    startDate = date ?? .now + 4
    self.peers = peers
    self.roomID = roomID
  }

  init(startDate: Date, peers: [Peer], roomID: String) {
    self.startDate = startDate
    self.peers = peers
    self.roomID = roomID
  }
}
