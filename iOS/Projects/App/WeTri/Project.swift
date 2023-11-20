//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍승현 on 11/10/23.
//

import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let projects = Project.makeModule(
  name: ProjectEnvironment.default.appName,
  targets: .app(
    name: ProjectEnvironment.default.targetName,
    dependencies: [
      .coordinator,
      .feature(.record),
    ]
  )
)
