import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "UserInformationManager",
  targets: .custom(
    name: "UserInformationManager",
    product: .framework,
    dependencies: [.cacher],
    resources: "Resources/**"
  )
)
