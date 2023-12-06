//
//  ImageFormRepository.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Trinet

// MARK: - ImageFormRepository

final class ImageFormRepository: ImageFormRepositoryRepresentable {
  func send(imageData: Data) -> String {
    return ""
  }
}

// MARK: - ImageFormEndPoint

enum ImageFormEndPoint: TNEndPoint {
  case image(Data)

  var boundary: String {
    return "Boundary-\(UUID().uuidString)"
  }

  var path: String {
    switch self {
    case .image:
      // TODO: Path
      return ""
    }
  }

  var method: TNMethod {
    switch self {
    case .image:
      return .post
    }
  }

  var query: Encodable? {
    return nil
  }

  var body: Encodable? {
    switch self {
    case let .image(data):
      return data
    }
  }

  var headers: TNHeaders {
    TNHeaders(headers: [
      TNHeader(key: "Content-Type", value: "multipart/form-data; boundary\(boundary)"),
    ])
  }
}
