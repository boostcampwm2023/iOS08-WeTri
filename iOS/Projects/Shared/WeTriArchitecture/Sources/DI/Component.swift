//
//  Component.swift
//  WeTriArchitecture
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - Component

/// 모든 컴포넌트의 기반이 됩니다.
open class Component<DependencyType>: Dependency {
  public let dependency: DependencyType

  public init(dependency: DependencyType) {
    self.dependency = dependency
  }
}

// MARK: - EmptyComponent

/// 비어있는 컴포넌트입니다.
open class EmptyComponent: EmptyDependency {
  public init() {}
}
