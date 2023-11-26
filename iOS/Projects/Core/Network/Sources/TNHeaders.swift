//
//  TNHeaders.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - TNHeaders

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

// MARK: CustomStringConvertible

extension TNHeaders: CustomStringConvertible {
  public var description: String {
    return headers.map(\.description).joined(separator: "\n")
  }
}

// MARK: ExpressibleByArrayLiteral

extension TNHeaders: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: TNHeader...) {
    self.init(headers: elements)
  }
}

// MARK: ExpressibleByDictionaryLiteral

extension TNHeaders: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, String)...) {
    self.init(headers: elements.map(TNHeader.init))
  }
}

// MARK: Collection

extension TNHeaders: Collection {
  public var startIndex: Int {
    headers.startIndex
  }

  public var endIndex: Int {
    headers.endIndex
  }

  public subscript(position: Int) -> TNHeader {
    headers[position]
  }

  public func index(after i: Int) -> Int {
    headers.index(after: i)
  }
}
