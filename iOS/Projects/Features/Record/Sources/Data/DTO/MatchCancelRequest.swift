//
//  MatchCancelRequest.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct MatchCancelRequest: Encodable {
  let workoutID: Int

  enum CodingKeys: String, CodingKey {
    case workoutID = "workoutId"
  }
}
