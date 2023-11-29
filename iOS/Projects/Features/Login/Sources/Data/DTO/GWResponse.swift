//
//  GWResponse.swift
//  LoginFeature
//
//  Created by 안종표 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct GWResponse<T>: Decodable where T: Decodable {
  let code: Int?
  let errorMessage: String?
  let data: T?
}
