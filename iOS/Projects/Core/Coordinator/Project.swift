//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 2023/11/16.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Coordinator",
  targets: .custom(name: "Coordinator", product: .framework)
)
