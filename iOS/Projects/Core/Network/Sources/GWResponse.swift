//
//  GWResponse.swift
//  Trinet
//
//  Created by 홍승현 on 12/8/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct GWResponse<T>: Decodable where T: Decodable {
  public let code: Int?
  public let errorMessage: String?
  public let data: T?
}
