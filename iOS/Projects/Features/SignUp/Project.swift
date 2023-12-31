import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SignUpFeature",
  targets: .feature(
    .signUp,
    testingOptions: [.unitTest],
    dependencies: [.trinet, .keychain, .combineCocoa, .coordinator, .log, .designSystem, .commonNetworkingKeyManager, .auth, .downSampling, .userInformationManager],
    testDependencies: [],
    resources: "Resources/**"
  )
)
