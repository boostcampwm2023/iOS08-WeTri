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
  public let imageDataList: [Data]
  public let mimeTypeList: [MimeType]

  public init(imageDataList: [Data], mimeTypeList: [MimeType] = []) {
    boundary = UUID().uuidString
    self.imageDataList = imageDataList
    self.mimeTypeList = mimeTypeList
  }

  public func makeBody() -> Data {
    let lineBreak = "\r\n"
    let boundaryPrefix = "--\(boundary)\(lineBreak)"

    var body = Data()

    for (imageData, mimeType) in zip(imageDataList, mimeTypeList) {
      let imageFieldName = "images"
      let filename = "image\(UUID().uuidString)"

      body.append(boundaryPrefix)
      body.append(#"Content-Disposition: form-data; name="\#(imageFieldName)"; filename="\#(filename)"\#(lineBreak)"#)
      body.append("Content-Type: \(mimeType.rawValue)\(lineBreak)\(lineBreak)")
      body.append(imageData)
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

public extension MultipartFormData {
  enum MimeType: String {
    case imagePNG = "image/png"
  }
}
