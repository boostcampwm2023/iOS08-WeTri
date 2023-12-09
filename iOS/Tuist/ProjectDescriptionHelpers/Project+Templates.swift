import EnvironmentPlugin
import ProjectDescription
import Foundation

private let isCI = ProcessInfo.processInfo.environment["TUIST_CI"] != nil
private let isDebug = ProcessInfo.processInfo.environment["TUIST_SCHEME"] == "DEBUG"

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

    let configurationName: ConfigurationName = isDebug ? .debug : .release
    let schemes: [Scheme] = [.makeScheme(configuration: configurationName, name: name)]

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
  static func makeScheme(configuration: ConfigurationName, name: String) -> Scheme {
    return Scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: configuration,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: configuration),
      archiveAction: .archiveAction(configuration: configuration),
      profileAction: .profileAction(configuration: configuration),
      analyzeAction: .analyzeAction(configuration: configuration)
    )
  }
}
