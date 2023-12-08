//
//  MultipartFormData.swift
//  Trinet
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - MultipartFormData

public struct MultipartFormData {
  private let boundary: String
  public let multipartItems: [MultipartItem]

  public init(multipartItems: [MultipartItem]) {
    boundary = UUID().uuidString
    self.multipartItems = multipartItems
  }

  public func makeBody() -> Data {
    let lineBreak = "\r\n"
    let boundaryPrefix = "--\(boundary)\(lineBreak)"

    var body = Data()

    for item in multipartItems {
      let imageFieldName = "images"
      let filename = "image\(UUID().uuidString)"

      body.append(boundaryPrefix)
      body.append(#"Content-Disposition: form-data; name="\#(imageFieldName)"; filename="\#(filename)"\#(lineBreak)"#)
      body.append("Content-Type: \(item.mimeType.rawValue)\(lineBreak)\(lineBreak)")
      body.append(item.data)
      body.append("\(lineBreak)")
    }

    // insert final boundary
    body.append("--\(boundary)--\(lineBreak)")

    return body
  }
}

private extension Data {
  mutating func append(_ string: String) {
    guard let data = string.data(using: .utf8) else {
      return
    }
    append(data)
  }
}