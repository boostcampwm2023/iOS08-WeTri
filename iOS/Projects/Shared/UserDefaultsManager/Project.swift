import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "UserDefaultsManager",
  targets: .custom(
    name: "UserDefaultsManager",
    product: .framework,
    testingOptions: [.unitTest]
  )
)
