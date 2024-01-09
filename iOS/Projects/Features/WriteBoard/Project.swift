import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "WriteBoardFeature",
  targets: .feature(
    .writeBoard,
    testingOptions: [.unitTest],
    dependencies: [.designSystem, .log, .combineCocoa, .trinet, .combineExtension, .coordinator, .commonNetworkingKeyManager],
    testDependencies: []
  )
)
