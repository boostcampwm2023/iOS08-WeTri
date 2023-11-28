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
      .keychain,
      .feature(.login)
    ],
    infoPlist: [
      "NSLocationAlwaysUsageDescription": "운동 경로를 보여줄 때 사용합니다",
      "NSLocationAlwaysAndWhenInUseUsageDescription": "운동 경로를 보여줄 때 사용합니다",
      "NSLocationWhenInUseUsageDescription": "운동 경로를 보여줄 때 사용합니다",
    ]
  )
)
