//
//  IsMatchedRandomPeersResponse.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - IsMatchedRandomPeersResponse

struct IsMatchedRandomPeersResponse: Decodable {
  let matched: Bool
  let liveWorkoutStartTime: String?
  let roomID: String?
  let peers: [IsMatchedRandomPeersForPeerResponse]?

  enum CodingKeys: String, CodingKey {
    case matched
    case liveWorkoutStartTime
    case roomID = "roomId"
    case peers
  }
}

// MARK: - IsMatchedRandomPeersForPeerResponse

struct IsMatchedRandomPeersForPeerResponse: Decodable {
  let nickname: String
  let publicID: String
  let profileImage: String
  let etc: String?

  enum CodingKeys: String, CodingKey {
    case nickname
    case publicID = "publicId"
    case profileImage
    case etc
  }
}
