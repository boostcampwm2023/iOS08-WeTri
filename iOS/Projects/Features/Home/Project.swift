import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "HomeFeature",
  targets: .feature(
    .home,
    testingOptions: [.unitTest],
    dependencies: [
      .designSystem,
      .log,
      .combineCocoa,
      .trinet,
      .combineExtension,
      .coordinator,
      .commonNetworkingKeyManager,
      .downSampling,
    ],
    testDependencies: [],
    resources: "Resources/**"
  )
)
