import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "OnBoradingScreenDemo",
  targets: .app(
    name: "OnBoradingScreenDemo",
    dependencies: [
      .feature(.signUp),
      .feature(.onboarding),
      .coordinator,
    ]
  )
)
