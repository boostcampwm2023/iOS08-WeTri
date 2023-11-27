//
//  MockEndPoint.swift
//  TrinetTests
//
//  Created by 홍승현 on 11/27/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Trinet

struct MockEndPoint: TNEndPoint {
  var baseURL: String = "base"
  var path: String = "path"
  var method: TNMethod = .get
  var query: Encodable? = nil
  var body: Encodable? = nil
  var headers: TNHeaders = []
}
