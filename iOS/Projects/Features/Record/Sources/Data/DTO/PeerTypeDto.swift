//
//  PeerTypeDto.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct PeerTypeDto: Decodable {
  let icon: String
  let title: String
  let description: String
  let typeCode: Int
}
