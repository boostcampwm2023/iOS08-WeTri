//
//  Response.swift
//  LoginFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - Response

struct Response {
  let code: Int?
  let errorMessage: String?
}

// MARK: Codable

extension Response: Codable {}
