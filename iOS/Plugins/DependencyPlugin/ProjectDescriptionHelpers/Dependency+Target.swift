//
//  Dependency+Target.swift
//  IOS
//
//  Created by 홍승현 on 11/19/23.
//

import ProjectDescription

// MARK: - Feature

public enum Feature: String {
  case login
  case onboarding
  case record

  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
}

public extension TargetDependency {
  static let designSystem: TargetDependency = .project(target: "DesignSystem", path: .relativeToShared("DesignSystem"))
  static let trinet: TargetDependency = .project(target: "Trinet", path: .relativeToCore("Network"))
  static let coordinator: TargetDependency = .project(target: "Coordinator", path: .relativeToCore("Coordinator"))
  static let combineCocoa: TargetDependency = .project(target: "CombineCocoa", path: .relativeToShared("CombineCocoa"))
  static let log: TargetDependency = .project(target: "Log", path: .relativeToShared("Log"))
  static let keychain: TargetDependency = .project(target: "Keychain", path: .relativeToCore("Keychain"))

  static func feature(_ feature: Feature) -> TargetDependency {
    return .project(
      target: "\(feature.targetName)Feature",
      path: .relativeToRoot("Projects/Features/\(feature.targetName)")
    )
  }
}
