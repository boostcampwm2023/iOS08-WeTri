//
//  TargetDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 11/14/23.
//

import ProjectDescription

public enum ProjectTargetDependency {
  public static let DesignSystem: TargetDependency = .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared/DesignSystem"))
  public static let Trinet: TargetDependency = .project(target: "Trinet", path: .relativeToRoot("Projects/Core/Network"))
  public static let Record: TargetDependency = .project(target: "RecordFeature", path: .relativeToRoot("Projects/Features/Record"))
  public static let TNCocoaCombine: TargetDependency = .project(target: "TNCombineCocoa", path: .relativeToRoot("Projects/Shared/TNCombineCocoa"))
}
