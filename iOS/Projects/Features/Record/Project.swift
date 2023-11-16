import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "RecordFeature",
  platform: .iOS,
  product: .framework,
  dependencies: [
    ProjectTargetDependency.Trinet,
    ProjectTargetDependency.DesignSystem,
    ProjectTargetDependency.WeTriArchitecture,
  ],
  isTestable: true
)
