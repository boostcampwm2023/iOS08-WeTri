//
//  MultipartItem.swift
//  Trinet
//
//  Created by 홍승현 on 12/8/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - MultipartItem

public struct MultipartItem {
  let data: Data
  let mimeType: MimeType
  let fileExtension: FileExtension

  public init(data: Data, mimeType: MimeType, fileExtension: FileExtension = .png) {
    self.data = data
    self.mimeType = mimeType
    self.fileExtension = fileExtension
  }

  public enum MimeType: String {
    case imagePNG = "image/png"
  }
}

// MARK: - FileExtension

public enum FileExtension: String {
  case png = ".png"
  case jpg = ".jpg"
  case jpeg = ".jpeg"
}
