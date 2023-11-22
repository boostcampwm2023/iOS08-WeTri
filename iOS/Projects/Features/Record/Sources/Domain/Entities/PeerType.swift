//
//  PeerType.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct PeerType: Hashable {
  let iconSystemImage: String
  let titleText: String
  let descriptionText: String
  let id = UUID()
  let typeCode: Int

  init(icon: String, title: String, description: String, typeCode: Int) {
    iconSystemImage = icon
    titleText = title
    descriptionText = description
    self.typeCode = typeCode
  }

  init(peerTypeDTO dto: PeerTypeDto) {
    iconSystemImage = dto.icon
    titleText = dto.title
    descriptionText = dto.description
    typeCode = dto.typeCode
  }
}