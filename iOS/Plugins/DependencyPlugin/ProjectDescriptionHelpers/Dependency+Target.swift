//
//  Dependency+Target.swift
//  IOS
//
//  Created by 홍승현 on 11/19/23.
//

import ProjectDescription

public enum Feature: String {
  case record

  public var targetName: String {
    rawValue.capitalized
  }
}

public extension TargetDependency {
  static let designSystem: TargetDependency = .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared/DesignSystem"))
  static let trinet: TargetDependency = .project(target: "Trinet", path: .relativeToRoot("Projects/Core/Network"))
  static let coordinator: TargetDependency = .project(target: "Coordinator", path: .relativeToRoot("Projects/Core/Coordinator"))
  static let combineCocoa: TargetDependency = .project(target: "CombineCocoa", path: .relativeToRoot("Projects/Shared/CombineCocoa"))

  static func feature(_ feature: Feature) -> TargetDependency {
    return .project(
      target: "\(feature.targetName)Feature",
      path: .relativeToRoot("Projects/Features/\(feature.targetName)")
    )
  }
}
