//
//  WorkoutRecordEndPoint.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Trinet

struct WorkoutRecordTestEndPoint: TNEndPoint {
  var baseURL: String = "??"
  var path: String = "??"
  var method: TNMethod = .post
  var query: Encodable?
  var body: Encodable?
  var headers: TNHeaders = .init(headers: [TNHeader(key: "dd", value: "ff")])
}
