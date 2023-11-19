import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "RecordFeature",
  platform: .iOS,
  product: .framework,
  dependencies: [
    .trinet,
    .designSystem,
    .combineCocoa,
  ],
  resources: nil,
  isTestable: true
)
