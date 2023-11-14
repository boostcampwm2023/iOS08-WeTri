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
