import ProjectDescription

public extension Project {
  static func makeModule(
    name: String,
    platform: Platform = .iOS,
    product: Product,
    organizationName: String = "kr.codesquad.boostcamp8",
    packages: [Package] = [],
    deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "16.0", devices: [.iphone]),
    dependencies: [TargetDependency] = [],
    sources: SourceFilesList = ["Sources/**"],
    resources: ResourceFileElements? = ["Resources/**"],
    infoPlist: InfoPlist = .default,
    isTestable: Bool = false
  )
    -> Project {
    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: [
        .debug(name: .debug),
        .release(name: .release),
      ]
    )

    let appTarget = Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: "\(organizationName).\(name)",
      deploymentTarget: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      scripts: [.swiftLint, .swiftFormat],
      dependencies: dependencies
    )

    let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]

    var targets: [Target] = [appTarget]

    if isTestable {
      let testTarget = Target(
        name: "\(name)Tests",
        platform: platform,
        product: .unitTests,
        bundleId: "\(organizationName).\(name)Tests",
        deploymentTarget: deploymentTarget,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [.target(name: name)]
      )

      targets.append(testTarget)
    }

    return Project(
      name: name,
      organizationName: organizationName,
      options: .options(automaticSchemesOptions: .disabled, disableBundleAccessors: true, disableSynthesizedResourceAccessors: true),
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}

extension Scheme {
  /// Scheme을 만드는 메소드
  static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
    return Scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: target,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: target),
      archiveAction: .archiveAction(configuration: target),
      profileAction: .profileAction(configuration: target),
      analyzeAction: .analyzeAction(configuration: target)
    )
  }
}
