import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "DesignSystem",
  targets: .custom(name: "DesignSystem", product: .framework)
)
