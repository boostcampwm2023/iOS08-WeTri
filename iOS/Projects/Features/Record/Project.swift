import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "RecordFeature",
  targets: .feature(
    .record,
    testingOptions: [.unitTest],
    dependencies: [.trinet, .designSystem, .combineCocoa, .combineExtension, .coordinator, .log, .commonNetworkingKeyManager, .cacher, .userDefaultsManager],
    testDependencies: [.trinet, .designSystem, .combineCocoa, .log, .cacher],
    resources: "Resources/**"
  )
)
