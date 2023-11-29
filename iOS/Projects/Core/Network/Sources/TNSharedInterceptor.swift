//
//  TNSharedInterceptor.swift
//  Trinet
//
//  Created by MaraMincho on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct TNSharedInterceptor: TNRequestInterceptor {
  func adapt(_ request: URLRequest, session _: URLSessionProtocol) -> URLRequest {
    return request
  }

  func retry(_ request: URLRequest, session _: URLSessionProtocol, data: Data, response: URLResponse, delegate _: URLSessionDelegate?) async throws -> (Data, URLResponse) {
    
    return (data, response)
  }
}
