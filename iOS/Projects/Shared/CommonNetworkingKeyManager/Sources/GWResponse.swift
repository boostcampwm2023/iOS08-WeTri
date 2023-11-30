//
//  GWResponse.swift
//  CommonNetworkingKeyManager
//
//  Created by MaraMincho on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - GWResponseForStatusCode

struct GWResponseForStatusCode: Decodable {
  let code: Int?
  let errorMessage: String?
}

// MARK: - GWResponse

struct GWResponse<T>: Decodable where T: Decodable {
  let code: Int?
  let errorMessage: String?
  let data: T?
}
