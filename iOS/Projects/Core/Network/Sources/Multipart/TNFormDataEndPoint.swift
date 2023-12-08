//
//  TNFormDataEndPoint.swift
//  Trinet
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - TNFormDataEndPoint

public protocol TNFormDataEndPoint {
  var baseURL: String { get }
  var path: String { get }
  var method: TNMethod { get }
  var body: Data? { get }
  var headers: TNHeaders { get }
}

public extension TNFormDataEndPoint {
  var baseURL: String {
    // request를 생성할 때 빈 문자열이면 invalidURL Error로 자연스레 들어갑니다.
    return Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
  }
}

public extension TNFormDataEndPoint {
  func request() throws -> URLRequest {
    guard let targetURL = URL(string: baseURL)?.appending(path: path)
    else {
      throw TNError.invalidURL
    }
    var request = URLRequest(url: targetURL)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers.dictionary
    request.httpBody = body
    return request
  }
}
