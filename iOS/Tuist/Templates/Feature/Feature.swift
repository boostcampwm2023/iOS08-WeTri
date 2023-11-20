//
//  Feature.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍승현 on 11/19/23.
//

import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
  description: "A template for a new module's demo target",
  attributes: [
    nameAttribute,
  ],
  items: [
    .file(
      path: "Projects/Features/\(nameAttribute)/Sources/TempScene/TempViewController.swift",
      templatePath: "TempViewController.stencil"
    ),
    .file(
      path: "Projects/Features/\(nameAttribute)/Sources/TempScene/TempViewViewModel.swift",
      templatePath: "TempViewModel.stencil"
    ),
    .file(
      path: "Projects/Features/\(nameAttribute)/Tests/TempFeatureTests.swift",
      templatePath: "TempViewModel.stencil"
    ),
  ]
)
