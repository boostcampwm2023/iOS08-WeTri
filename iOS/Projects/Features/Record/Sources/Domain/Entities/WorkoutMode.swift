//
//  WorkoutMode.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - WorkoutMode

enum WorkoutMode: Int {
  case run = 1
  case swim = 2
  case cycle = 3
}

// MARK: CustomStringConvertible

extension WorkoutMode: CustomStringConvertible {
  var code: Int { rawValue }
  var description: String {
    switch self {
    case .run:
      return "달리기"
    case .swim:
      return "수영"
    case .cycle:
      return "자전거"
    }
  }
}

// MARK: Codable

extension WorkoutMode: Codable {}
