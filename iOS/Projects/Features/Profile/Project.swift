import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ProfileFeature",
  targets: .feature(
    .profile,
    testingOptions: [.unitTest],
    dependencies: [
      .designSystem,
      .trinet,
      .combineExtension,
      .combineCocoa,
      .log,
      .coordinator,
      .commonNetworkingKeyManager,
      .userInformationManager,
    ],
    testDependencies: [],
    resources: "Resources/**"
  )
)
