//
//  IsMatchedRandomPeersRequest.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct IsMatchedRandomPeersRequest: Encodable {
  let workoutID: Int
  let waitingTime: Int
}
