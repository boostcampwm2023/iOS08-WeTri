import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Cacher",
  targets: .custom(
    name: "Cacher",
    product: .framework,
    testingOptions: [.unitTest],
    dependencies: [.log]
  )
)
