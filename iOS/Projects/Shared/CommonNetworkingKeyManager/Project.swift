import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "CommonNetworkingKeyManager",
  targets: .custom(
    name: "CommonNetworkingKeyManager",
    product: .framework,
    dependencies: [.log, .keychain, .trinet]
  )
)
