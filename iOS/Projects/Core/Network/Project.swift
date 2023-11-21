import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Trinet",
  targets: .custom(name: "Trinet", product: .framework, testingOptions: [.unitTest])
)
