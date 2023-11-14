//
//  TNError.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public enum TNError: LocalizedError {
  case invalidURL

  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "URL이 잘못되었습니다."
    }
  }
}
