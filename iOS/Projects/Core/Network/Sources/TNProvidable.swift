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
  func request(_ service: EndPoint, successStatusCodeRange: Range<Int>) async throws -> Data
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

  public func request(_ service: T, successStatusCodeRange range: Range<Int> = 200 ..< 300) async throws -> Data {
    let (data, response) = try await session.data(for: service.request(), delegate: nil)
    guard let httpResponse = (response as? HTTPURLResponse) else {
      throw TNError.httpResponseDownCastingError
    }
    try checkStatusCode(httpResponse.statusCode, successStatusCodeRange: range)

    return data
  }
}

private extension TNProvider {
  func checkStatusCode(_ statusCode: Int, successStatusCodeRange: Range<Int>) throws {
    switch statusCode {
    case successStatusCodeRange:
      return
    case 300 ..< 400:
      throw TNError.redirectError
    case 400 ..< 500:
      throw TNError.clientError
    case 500 ..< 600:
      throw TNError.serverError
    default:
      throw TNError.unknownError
    }
  }
}
