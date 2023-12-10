//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 12/10/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ImageDownsampling",
  targets: .custom(
    name: "ImageDownsampling",
    product: .framework,
    testingOptions: []
  )
)
