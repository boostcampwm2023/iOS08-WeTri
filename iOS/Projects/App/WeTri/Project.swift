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
    entitlements: .file(path: .relativeToApp("WeTri/WeTri.entitlements")),
    dependencies: [
      .coordinator,
      .feature(.record),
      .feature(.onboarding),
      .feature(.login),
      .feature(.splash),
      .feature(.signUp),
      .feature(.profile),
      .keychain,
    ],
    infoPlist: [
      "NSLocationAlwaysUsageDescription": "운동 경로를 보여줄 때 사용합니다",
      "NSLocationAlwaysAndWhenInUseUsageDescription": "운동 경로를 보여줄 때 사용합니다",
      "NSLocationWhenInUseUsageDescription": "운동 경로를 보여줄 때 사용합니다",
      "NSHealthShareUsageDescription": "운동 시 건강 데이터를 공유합니다",
      "NSHealthUpdateUsageDescription": "운동 시 건강 데이터를 업데이트합니다",
      "NSPhotoLibraryUsageDescription": "앨범에 접근합니다",
    ]
  )
)
