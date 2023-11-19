//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍승현 on 11/10/23.
//

import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "WeTri",
  product: .app,
  dependencies: [
    .coordinator,
    .feature(.record),
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(
    with: [
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
          "UIWindowSceneSessionRoleApplication": [
            [
              "UISceneConfigurationName": "Default Configuration",
              "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
            ],
          ],
        ],
      ],
    ]
  )
)
