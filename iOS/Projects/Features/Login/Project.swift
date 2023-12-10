import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "LoginFeature",
  targets: .feature(
    .login,
    testingOptions: [.unitTest],
    dependencies: [.trinet, .keychain, .combineCocoa, .log, .auth],
    testDependencies: [],
    resources: "Resources/**"
  )
)
