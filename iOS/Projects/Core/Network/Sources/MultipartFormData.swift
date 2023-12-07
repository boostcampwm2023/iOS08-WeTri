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
  private let mimeType: String
  public let imageDataList: [Data]

  public init(uuid: UUID = UUID(), mimeType: String, imageDataList: [Data]) {
    boundary = "Boundary-\(uuid.uuidString)"
    self.mimeType = mimeType
    self.imageDataList = imageDataList
  }

  public func makeBody() -> Data {
    let lineBreak = "\r\n"
    let boundaryPrefix = "--\(boundary)\(lineBreak)"

    var body = Data()

    for (index, imageData) in imageDataList.enumerated() {
      let imgDataKey = "images"
      let filename = "image[\(index)]"

      body.append(boundaryPrefix)
      body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\(lineBreak)")
      body.append("Content-Type: \(mimeType)\(lineBreak)\(lineBreak)")
      body.append(imageData)
      body.append("\(lineBreak)")
      body.append("\(boundaryPrefix)")
    }

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
