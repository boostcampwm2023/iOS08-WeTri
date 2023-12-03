//
//  withUnretained.swift
//  CombineCocoa
//
//  Created by 홍승현 on 12/1/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

public extension Publisher {
  func withUnretained<Owner: AnyObject>(_ owner: Owner) -> Publishers.TryMap<Self, (Owner, Self.Output)> {
    tryMap { [weak owner] output in
      guard let owner else { throw UnretainedError.failedRetaining }
      return (owner, output)
    }
  }
}

// MARK: - UnretainedError

private enum UnretainedError: Error {
  case failedRetaining
}
