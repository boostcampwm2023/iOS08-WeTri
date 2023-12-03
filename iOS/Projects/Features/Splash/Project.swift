import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SplashFeature",
  targets: .feature(
    .splash,
    testingOptions: [.unitTest],
    dependencies: [.designSystem, .log, .commonNetworkingKeyManager, .trinet, .keychain],
    testDependencies: []
  )
)
