//
//  ImageFormRepository.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log
import Trinet

// MARK: - ImageFormRepositoryError

enum ImageFormRepositoryError: Error {
  case invalidImageFormRepository
}

// MARK: - ImageFormRepository

public final class ImageFormRepository: ImageFormRepositoryRepresentable {
  private let provider: TNProvider<ImageFormEndPoint>

  public init(urlSession: URLSessionProtocol) {
    provider = TNProvider(session: urlSession)
  }

  public func send(imageData: Data) -> AnyPublisher<[ImageForm], Error> {
    Log.make().debug("\(imageData)")
    return Future<Data, Error> { [weak self] promise in
      guard let self else {
        return promise(.failure(ImageFormRepositoryError.invalidImageFormRepository))
      }
      let boundary = "Boundary-\(UUID().uuidString)"
      let body = createBody(parameters: [:], boundary: boundary, data: imageData, mimeType: "image/png", filename: "임의설정")
      let endPoint = ImageFormEndPoint.image(body, boundary)
      Task {
        do {
          let data = try await self.provider.request(endPoint)
          promise(.success(data))
        } catch {
          promise(.failure(error))
        }
      }
    }
    .decode(type: GWResponse<[ImageForm]>.self, decoder: JSONDecoder())
    .compactMap(\.data)
    .eraseToAnyPublisher()
  }

  private func createBody(parameters _: [String: String],
                          boundary: String,
                          data: Data,
                          mimeType: String,
                          filename: String) -> Data {
    var body = Data()
    let imgDataKey = "images"
    let boundaryPrefix = "--\(boundary)\r\n"

//    for (key, value) in parameters {
//      body.append(boundaryPrefix.data(using: .utf8)!)
//      body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//      body.append("\(value)\r\n".data(using: .utf8)!)
//    }

    body.append(boundaryPrefix.data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
    body.append(data)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--".appending(boundary.appending("--")).data(using: .utf8)!)

    return body as Data
  }
}

// MARK: - ImageFormEndPoint

enum ImageFormEndPoint: TNEndPoint {
  case image(Data, String)

  var boundary: String {
    switch self {
    case let .image(_, providedBoundary):
      return providedBoundary
    }
  }

  var path: String {
    switch self {
    case .image:
      return "/api/v1/images"
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
    case let .image(formData, _):
      return formData
    }
  }

  var headers: TNHeaders {
    TNHeaders(headers: [
      TNHeader(key: "Content-Type", value: "multipart/form-data; boundary\(boundary)"),
    ])
  }
}
