//
//  TNEndPoint.swift
//  Trinet
//
//  Created by MaraMincho on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public protocol TNEndPoint {
  var baseURL: String { get }
  var path: String { get }
  var method: TNMethod { get }
  var query: Encodable? { get }
  var body: Encodable? { get }
  var headers: TNHeaders { get }
}
