//
//  TNRequestInterceptor.swift
//  Trinet
//
//  Created by MaraMincho on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - TNRequestAdaptor

/// 네트워크 통신 직전 urlRequest를 얻는다.
/// 얻어진 urlRequest를 통해 적절한 작업을 통해 URLRequest를 리턴한다.
/// eg) AccessToken을 추가한다거나, contentType header를 추가한다.
public protocol TNRequestAdaptor {
  func adapt(_ request: URLRequest, session: URLSessionProtocol) -> URLRequest
}

// MARK: - TNRequestRetrier

/// 네트워크 통신 하자마자 얻은 데이터를 인풋으로 얻는다.
/// 얻은 인풋을 적절한 작업을 통해 재 전송하거나, 다른 작업을 취한다.
/// TriNet의 기본 Data요청인 async await을 통한 데이터 return타입을 따른다
/// eg) 현재 매개변수인 response를 적절하게 파싱하여 statusCode를 얻고, 이에 따라 Redirect를 보낸다
public protocol TNRequestRetrier {
  func retry(
    _ request: URLRequest,
    session: URLSessionProtocol,
    data: Data,
    response: URLResponse,
    delegate: URLSessionDelegate?
  ) async throws -> (Data, URLResponse)
}

public typealias TNRequestInterceptor = TNRequestAdaptor & TNRequestRetrier
