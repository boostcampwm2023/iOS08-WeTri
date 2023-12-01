import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "OnboardingFeature",
  targets: .feature(
    .onboarding,
    testingOptions: [.unitTest],
    dependencies: [.designSystem, .combineCocoa, .coordinator, .log],
    testDependencies: [.designSystem, .combineCocoa, .log],
    resources: "Resources/**"
  )
)
