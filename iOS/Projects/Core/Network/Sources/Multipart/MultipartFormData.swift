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
  private let imageDataList: [Data]

  public let multipartItems: [MultipartItem]

  public init(
    uuid: UUID,
    mimeType _: String = "image/png",
    imageDataList: [Data]
  ) {
    boundary = "\(uuid.uuidString)"
    multipartItems = imageDataList.map { MultipartItem(data: $0, mimeType: .imagePNG) }
    self.imageDataList = imageDataList
  }

  public init(uuid: UUID, multipartItems: [MultipartItem]) {
    boundary = uuid.uuidString
    self.multipartItems = multipartItems
    imageDataList = []
  }

  public func makeBody() -> Data {
    let lineBreak = "\r\n"
    let boundaryPrefix = "--\(boundary)\(lineBreak)"

    var body = Data()

    for item in multipartItems {
      let imageFieldName = "images"
      let filename = "image\(UUID().uuidString)\(item.fileExtension.rawValue)"

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
