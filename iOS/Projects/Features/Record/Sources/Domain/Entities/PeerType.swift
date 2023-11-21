//
//  PeerType.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct PeerType: Hashable {
  let icon: String
  let title: String
  let description: String
  let id = UUID()

  init(icon: String, title: String, description: String) {
    self.icon = icon
    self.title = title
    self.description = description
  }

  init(peerTypeDTO dto: PeerTypeDto) {
    icon = dto.icon
    title = dto.title
    description = dto.description
  }
}
