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
  func request(_ service: EndPoint, successStatusCodeRange range: Range<Int>, interceptor: TNRequestInterceptor) async throws -> Data
}

// MARK: - TNProvider

public struct TNProvider<T: TNEndPoint>: TNProvidable {
  private let session: URLSessionProtocol

  public init(session: URLSessionProtocol) {
    self.session = session
  }

  public func uploadRequest(_ service: T, successStatusCodeRange range: Range<Int> = 200 ..< 300, interceptor: TNRequestInterceptor) async throws -> Data {
    guard let multipart = service.multipart else { throw TNError.unknownError }
    let request = try interceptor.adapt(service.request(), session: session)
    let (data, response) = try await session.upload(for: request, from: multipart.makeBody())
    let (retriedData, retriedResponse) = try await interceptor.retry(request, session: session, data: data, response: response, delegate: nil)
    try checkStatusCode(retriedResponse, successStatusCodeRange: range)
    return retriedData
  }

  public func uploadRequest(_ service: T, successStatusCodeRange range: Range<Int> = 200 ..< 300) async throws -> Data {
    guard let multipart = service.multipart else { throw TNError.unknownError }
    let (data, response) = try await session.upload(for: service.requestFormData(), from: multipart.makeBody())
    try checkStatusCode(response, successStatusCodeRange: range)
    return data
  }

  public func request(_ service: T, completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    try session.dataTask(with: service.request(), completionHandler: completion).resume()
  }

  public func request(_ service: T, successStatusCodeRange range: Range<Int> = 200 ..< 300) async throws -> Data {
    let (data, response) = try await session.data(for: service.request(), delegate: nil)
    let res = try JSONDecoder().decode(Response.self, from: data)
    print("코드 : \(res.code)")
    print("에러 메시지 : \(res.errorMessage)")
    try checkStatusCode(response, successStatusCodeRange: range)
    return data
  }

  public func request(_ service: T, successStatusCodeRange range: Range<Int> = 200 ..< 300, interceptor: TNRequestInterceptor) async throws -> Data {
    let request = try interceptor.adapt(service.request(), session: session)
    let (data, response) = try await session.data(for: request, delegate: nil)
    let (retriedData, retriedResponse) = try await interceptor.retry(request, session: session, data: data, response: response, delegate: nil)
    try checkStatusCode(retriedResponse, successStatusCodeRange: range)

    return retriedData
  }
}

private extension TNProvider {
  func checkStatusCode(_ urlResponse: URLResponse, successStatusCodeRange: Range<Int>) throws {
    guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
      throw TNError.httpResponseDownCastingError
    }
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

// MARK: - Response

private struct Response: Codable {
  let code: Int?
  let errorMessage: String?
}
