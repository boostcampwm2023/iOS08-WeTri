//
//  TNHeader.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// HTTP 헤더를 나타냅니다.
public struct TNHeader: Hashable {
  let key: String
  let value: String

  public init(key: String, value: String) {
    self.key = key
    self.value = value
  }
}
