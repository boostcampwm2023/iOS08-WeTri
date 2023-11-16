//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍승현 on 11/16/23.
//

import Foundation

// MARK: - Dependency

/// Dependency Protocol의 기반이 되는 프로토콜입니다.
public protocol Dependency: AnyObject {}

// MARK: - EmptyDependency

/// Dependency가 비어있을 때 사용합니다.
public protocol EmptyDependency: Dependency {}
