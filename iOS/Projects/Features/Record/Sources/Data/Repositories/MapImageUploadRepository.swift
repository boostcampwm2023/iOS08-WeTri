//
//  MapImageUploadRepository.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CommonNetworkingKeyManager
import Foundation
import Trinet

// MARK: - MapImageUploadRepository

struct MapImageUploadRepository: MapImageUploadRepositoryRepresentable {
  private let provider: TNProvider<ImageUploadEndPoint>

  init(session: URLSessionProtocol) {
    provider = .init(session: session)
  }

  func upload(with imageData: Data) -> AnyPublisher<URL, Error> {
    return Future<Data, Error> { promise in
      Task {
        do {
          let data = try await provider.uploadRequest(ImageUploadEndPoint(data: [imageData]), interceptor: TNKeychainInterceptor.shared)
          promise(.success(data))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .decode(type: GWResponse<ImageModel>.self, decoder: JSONDecoder())
    .compactMap(\.data)
    .map(\.imageURL)
    .eraseToAnyPublisher()
  }
}

// MARK: - ImageUploadEndPoint

private struct ImageUploadEndPoint: TNEndPoint {
  let path: String = "api/v1/images"

  let method: TNMethod = .post

  let query: Encodable? = nil

  var body: Encodable? = nil

  let headers: TNHeaders

  var multipart: MultipartFormData?

  init(data: [Data]) {
    let boundary: UUID = .init()
    headers = [
      .accept("application/json"),
      .contentType("multipart/form-data; boundary=\(boundary.uuidString)"),
    ]
    multipart = .init(multipartItems: data.map { MultipartItem(data: $0, mimeType: .imagePNG) })
  }
}

// MARK: - ImageModel

struct ImageModel: Codable {
  let imageName: String
  let imageURL: URL

  enum CodingKeys: String, CodingKey {
    case imageName
    case imageURL = "imageUrl"
  }
}
