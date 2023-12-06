import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "UserInformationManager",
  targets: .custom(
    name: "UserInformationManager",
    product: .framework,
    testingOptions: [.unitTest],
    dependencies: [.cacher],
    testDependencies: [.cacher]
  )
)
