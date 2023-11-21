//
//  Injectable.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

protocol Injectable: AnyObject {
  var dependencies: [String: Any] { get set }
  func register<T>(_ dependency: T)
  func resolve<T>() -> T
  func fillUp()
}
