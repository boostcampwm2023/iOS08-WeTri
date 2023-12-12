//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 12/9/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Auth",
  targets: .custom(
    name: "Auth",
    product: .framework,
    testingOptions: []
  )
)
