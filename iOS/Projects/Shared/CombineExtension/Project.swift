import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "CombineExtension",
  targets: .custom(
    name: "CombineExtension",
    product: .framework,
    testingOptions: [.unitTest]
  )
)
