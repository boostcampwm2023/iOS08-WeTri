import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "LoginFeature",
  targets: .feature(
    .login,
    testingOptions: [.unitTest],
    dependencies: [.trinet, .keychain, .combineCocoa, .log, TargetDependency.feature(.signUp)],
    testDependencies: [],
    resources: "Resources/**"
  )
)
