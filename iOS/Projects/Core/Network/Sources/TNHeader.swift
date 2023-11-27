//
//  TNHeader.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - TNHeader

/// HTTP 헤더를 나타냅니다.
public struct TNHeader: Hashable {
  let key: String
  let value: String

  public init(key: String, value: String) {
    self.key = key
    self.value = value
  }
}

public extension TNHeader {
  static func accept(_ value: String) -> Self {
    TNHeader(key: "Accept", value: value)
  }

  static func contentType(_ value: String) -> Self {
    TNHeader(key: "Content-Type", value: value)
  }

  static func authorization(bearer token: String) -> Self {
    TNHeader(key: "Authorization", value: "Bearer \(token)")
  }
}

// MARK: CustomStringConvertible

extension TNHeader: CustomStringConvertible {
  public var description: String {
    return "\(key): \(value)"
  }
}
