import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
    description: "A template for a new module's demo target",
    attributes: [
        nameAttribute
    ],
    items: [
        .file(
            path: "Projects/App/\(nameAttribute)/Resources/LaunchScreen.storyboard",
            templatePath: "LaunchScreen.stencil"
        ),
        .file(
            path: "Projects/App/\(nameAttribute)/Sources/Application/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        ),
        .file(
          path: "Projects/App/\(nameAttribute)/Sources/Application/SceneDelegate.swift",
          templatePath: "SceneDelegate.stencil"
        )
    ]
)
