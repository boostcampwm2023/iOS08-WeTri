//
//  MapImageUploadRepository.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Trinet

// MARK: - MapImageUploadRepository

struct MapImageUploadRepository: MapImageUploadRepositoryRepresentable {
  private let provider: TNProvider<ImageUploadEndPoint>

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }
}

// MARK: - ImageUploadEndPoint

private struct ImageUploadEndPoint: TNEndPoint {
  let path: String = "api/v1/images"

  let method: TNMethod = .post

  let query: Encodable? = nil

  var body: Encodable?

  let headers: TNHeaders = [
    .accept("application/json"),
    .contentType("multipart/form-data"),
  ]
}
