//
//  Record.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - Record

struct Record {
  let mode: WorkoutMode
  let timeToTime: String
  let distance: Double
}

// MARK: Codable

extension Record: Codable {}
