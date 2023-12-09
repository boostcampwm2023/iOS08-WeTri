import EnvironmentPlugin
import ProjectDescription
import Foundation

private let isCI = ProcessInfo.processInfo.environment["TUIST_CI"] != nil

public extension Project {
  static func makeModule(
    name: String,
    organizationName: String = ProjectEnvironment.default.prefixBundleID,
    targets: [Target],
    packages: [Package] = []
  ) -> Project {
    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: [
        .debug(name: .debug, xcconfig: isCI ? nil : .relativeToXCConfig("Server/Debug")),
        .release(name: .release, xcconfig: isCI ? nil : .relativeToXCConfig("Server/Release")),
      ]
    )

    let schemes: [Scheme] = [
      .makeScheme(target: .debug, targetName: name, schemeName: "\(name)-Debug"),
      .makeScheme(target: .release, targetName: name, schemeName: "\(name)-Release")
    ]

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
  static func makeScheme(target: ConfigurationName, targetName: String, schemeName: String) -> Scheme {
    return Scheme(
      name: schemeName,
      shared: true,
      buildAction: .buildAction(targets: ["\(targetName)"]),
      testAction: .targets(
        ["\(targetName)Tests"],
        configuration: target,
        options: .options(coverage: true, codeCoverageTargets: ["\(targetName)"])
      ),
      runAction: .runAction(configuration: target),
      archiveAction: .archiveAction(configuration: target),
      profileAction: .profileAction(configuration: target),
      analyzeAction: .analyzeAction(configuration: target)
    )
  }
}
