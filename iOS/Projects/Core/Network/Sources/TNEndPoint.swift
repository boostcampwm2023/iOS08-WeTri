//
//  TNEndPoint.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - TNEndPoint

public protocol TNEndPoint {
  var baseURL: String { get }
  var path: String { get }
  var method: TNMethod { get }
  var query: Encodable? { get }
  var body: Encodable? { get }
  var headers: TNHeaders { get }
  var multipart: MultipartFormData? { get }
}

public extension TNEndPoint {
  var baseURL: String {
    // request를 생성할 때 빈 문자열이면 invalidURL Error로 자연스레 들어갑니다.
    return Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
  }

  var multipart: MultipartFormData? {
    return nil
  }
}

public extension TNEndPoint {
  func request() throws -> URLRequest {
    guard let targetURL = URL(string: baseURL)?.appending(path: path).appending(query: query)
    else {
      throw TNError.invalidURL
    }
    var request = URLRequest(url: targetURL)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers.dictionary
    request.httpBody = body?.data

    return request
  }
}

private extension URL {
  func appending(query: Encodable?) -> URL? {
    guard let query else {
      return self
    }
    var urlComponents = URLComponents(string: absoluteString)
    urlComponents?.queryItems = query.dictionary.map { (key: String, value: Any) in
      return URLQueryItem(name: key, value: "\(value)")
    }
    return urlComponents?.url
  }
}

private extension Encodable {
  var data: Data? {
    return try? JSONEncoder().encode(self)
  }

  var dictionary: [String: Any] {
    guard
      let data = try? JSONEncoder().encode(self),
      let jsonData = try? JSONSerialization.jsonObject(with: data),
      let dictionaryTarget = jsonData as? [String: Any]
    else {
      return [:]
    }

    return dictionaryTarget
  }
}

// MARK: - MultipartFormData

public struct MultipartFormData {
  public var data: Data = .init()

  let boundary: UUID

  public init(boundary: UUID, data: [Data], mimeType: String = "image/png") {
    self.boundary = boundary
    self.data = createBody(boundary: boundary.uuidString, imageData: data, mimeType: mimeType)
  }

  private mutating func createBody(boundary: String, imageData: [Data], mimeType: String) -> Data {
    let linebreak = "\r\n"
    let boundaryPrefix = "--\(boundary)\(linebreak)"

    var body = Data()
    // 각 이미지 데이터를 멀티파트 형식으로 추가
    for (index, imageData) in imageData.enumerated() {
      let imgDataKey = "images"
      let filename = "image[\(index)]"

      body.append(boundaryPrefix)
      body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\(linebreak)")
      body.append("Content-Type: \(mimeType)\(linebreak)\(linebreak)")
      body.append(imageData)
      body.append("\(linebreak)")
      body.append("--\(boundary)\(linebreak)")
    }

    // 종결 바운더리 추가
    body.append("--\(boundary)--\(linebreak)")

    return body
  }
}

private extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}
