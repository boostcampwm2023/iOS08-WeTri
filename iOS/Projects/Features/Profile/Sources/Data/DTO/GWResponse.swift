//
//  GWResponse.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct GWResponse<T>: Decodable where T: Decodable {
  let code: Int?
  let errorMessage: String?
  let data: T?
}
