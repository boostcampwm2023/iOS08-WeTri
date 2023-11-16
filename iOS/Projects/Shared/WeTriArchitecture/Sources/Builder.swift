//
//  Builder.swift
//  WeTriArchitecture
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

// MARK: - Buildable

public protocol Buildable: AnyObject {}

// MARK: - Builder

open class Builder<DependencyType>: Buildable {
  public let dependency: DependencyType

  public init(dependency: DependencyType) {
    self.dependency = dependency
  }
}
