import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "CombineCocoa",
  targets: .custom(
    name: "CombineCocoa",
    product: .framework,
    testingOptions: [.unitTest]
  )
)
