//
//  TNHeaders.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct TNHeaders: Hashable {
  private var headers: [TNHeader]

  public init(headers: [TNHeader]) {
    self.headers = headers
  }

  var dictionary: [String: String] {
    let headersTuple = headers.map { ($0.key, $0.value) }
    return Dictionary(uniqueKeysWithValues: headersTuple)
  }
}

extension TNHeaders: CustomStringConvertible {
  public var description: String {
    return headers.map(\.description).joined(separator: "\n")
  }
}
