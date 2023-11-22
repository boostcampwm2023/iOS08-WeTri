//
//  WorkoutMode.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - WorkoutMode

enum WorkoutMode {
  case run
  case swim
  case cycle
}

extension WorkoutMode {
  var decription: String {
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
