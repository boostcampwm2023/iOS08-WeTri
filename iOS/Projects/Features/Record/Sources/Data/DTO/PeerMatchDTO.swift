//
//  PeerMatchDTO.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - PeerMatchResponseDTO

struct PeerMatchResponseDTO: Codable {
  let roomURLString: String
  let peersDTO: [PeerDTO]

  enum CodingKeys: String, CodingKey {
    case roomURLString = "url"
    case peersDTO = "peers"
  }
}

// MARK: - PeerDTO

struct PeerDTO: Codable {
  let profileImageURL: String
  let name: String

  enum CodingKeys: String, CodingKey {
    case profileImageURL = "profileImage"
    case name = "nickname"
  }
}
