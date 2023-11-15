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
}