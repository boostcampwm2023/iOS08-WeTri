//
//  TNProvidable.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - TNProvidable

public protocol TNProvidable {
  associatedtype EndPoint = TNEndPoint
  func request(_ service: EndPoint, statusCodeRange: Range<Int>) async throws -> Data
  func request(_ service: EndPoint, completion: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) throws
}

// MARK: - TNProvider

public struct TNProvider<T: TNEndPoint>: TNProvidable {
  private let session: URLSessionProtocol

  public init(session: URLSessionProtocol) {
    self.session = session
  }

  public func request(_ service: T, completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    try session.dataTask(with: service.request(), completionHandler: completion).resume()
  }

  public func request(_ service: T, statusCodeRange: Range<Int> = 200 ..< 300) async throws -> Data {
    // TODO: URLResponse에 대응하는 코드 작성(backend 내려주는 API 문서 활용)

    let (data, response) = try await session.data(for: service.request(), delegate: nil)
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
          statusCodeRange ~= statusCode
    else {
      throw TNError.invalidURL
    }

    return data
  }
}
