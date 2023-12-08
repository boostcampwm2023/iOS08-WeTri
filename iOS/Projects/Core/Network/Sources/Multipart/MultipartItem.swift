//
//  MultipartItem.swift
//  Trinet
//
//  Created by 홍승현 on 12/8/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct MultipartItem {
  let data: Data
  let mimeType: MimeType

  public init(data: Data, mimeType: MimeType) {
    self.data = data
    self.mimeType = mimeType
  }

  public enum MimeType: String {
    case imagePNG = "image/png"
  }
}
