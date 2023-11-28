//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 11/28/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Keychain",
  targets: .custom(name: "Keychain", product: .framework, testingOptions: [.unitTest])
)
