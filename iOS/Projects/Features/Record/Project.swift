import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "RecordFeature",
  targets: .feature(
    .record,
    testingOptions: [.unitTest],
    dependencies: [.trinet, .designSystem, .combineCocoa],
    testDependencies: [.trinet, .designSystem, .combineCocoa]
  )
)
