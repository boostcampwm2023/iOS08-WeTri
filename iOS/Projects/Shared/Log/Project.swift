import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Log",
  targets: .custom(name: "Log", product: .framework)
)
