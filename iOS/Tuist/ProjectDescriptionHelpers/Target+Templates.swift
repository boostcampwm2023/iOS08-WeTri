//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 홍승현 on 11/20/23.
//

import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription

// MARK: - TestingOption

public enum TestingOption {
  case unitTest
  case uiTest
}

public extension [Target] {
  /// App으로 실행가능한 모듈을 만들 때 사용합니다.
  /// - Parameters:
  ///   - name: App Target 이름
  ///   - testingOptions: App Target에서 추가할 테스트 옵션들
  ///   - dependencies: App의 의존성
  ///   - testDependencies: App에서 만들어지는 테스트 모듈의 의존성. `testingOptions`파라미터가 nil이 아닐 때 유효합니다.
  ///   - infoPlist: App에서 설정할 infoPlist
  static func app(
    name: String,
    testingOptions: Set<TestingOption> = [],
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    infoPlist: [String: Plist.Value] = [:]
  ) -> [Target] {

    let mergedInfoPlist: [String: Plist.Value] = [
      "BaseURL": "$(BASE_URL)",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
          "UIWindowSceneSessionRoleApplication": [
            [
              "UISceneConfigurationName": "Default Configuration",
              "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
            ],
          ],
        ],
      ],
    ].merging(infoPlist) { _, new in
      new
    }

    var targets: [Target] = [
      Target(
        name: name,
        platform: .iOS,
        product: .app,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())",
        deploymentTarget: ProjectEnvironment.default.deploymentTarget,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: "Resources/**",
        scripts: [.swiftFormat, .swiftLint],
        dependencies: dependencies
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target(
          name: "\(name)Tests",
          platform: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())Tests",
          sources: "Tests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: name)]
        )
      )
    }
    if testingOptions.contains(.uiTest) {
      targets.append(
        Target(
          name: "\(name)UITests",
          platform: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())UITests",
          sources: "UITests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: name)]
        )
      )
    }

    return targets
  }

  /// Feature 모듈의 `Target`을 생성합니다.
  /// - Parameters:
  ///   - feature: Feature Module
  ///   - testingOptions: Feature에서 추가할 테스트 옵션들
  ///   - dependencies: Feature의 의존성
  ///   - testDependencies: Feature에서 만들어지는 테스트들의 의존성. `testingOptions`파라미터가 nil이 아닐 때 유효합니다.
  ///   - infoPlist: Feature에서 설정할 infoPlist
  ///   - resources: 리소스 사용 경로, 기본값은 nil입니다. 만약 사용하고 싶다면 경로를 지정해주세요.
  /// - Returns: Feature 모듈의 Target 리스트
  static func feature(
    _ feature: Feature,
    testingOptions: Set<TestingOption> = [],
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    infoPlist: [String: Plist.Value] = [:],
    resources: ResourceFileElements? = nil
  ) -> [Target] {

    let mergedInfoPlist: [String: Plist.Value] = ["BaseURL": "$(BASE_URL)"].merging(infoPlist) { _, new in
      new
    }

    // 에셋 리소스를 코드로 자동완성 해주는 옵션 활성화
    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: [
        .debug(name: .debug),
        .release(name: .release),
      ]
    )

    var targets: [Target] = [
      Target(
        name: "\(feature.targetName)Feature",
        platform: .iOS,
        product: .framework,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)Feature",
        deploymentTarget: ProjectEnvironment.default.deploymentTarget,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: resources,
        scripts: [.swiftFormat, .swiftLint],
        dependencies: dependencies,
        settings: settings
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target(
          name: "\(feature.targetName)FeatureTests",
          platform: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)FeatureTests",
          sources: "Tests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: "\(feature.targetName)Feature")]
        )
      )
    }

    if testingOptions.contains(.uiTest) {
      targets.append(
        Target(
          name: "\(feature.targetName)FeatureUITests",
          platform: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)FeatureUITests",
          sources: "UITests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: "\(feature.targetName)Feature")]
        )
      )
    }

    return targets
  }

  /// Target을 사용자화하여 생성합니다.
  /// - Parameters:
  ///   - name: Target 이름
  ///   - product: Target Product
  ///   - testingOptions: Target에서 추가할 테스트 옵션들
  ///   - dependencies: Target의 의존성
  ///   - testDependencies: Target의 테스트 모듈의 의존성. `testingOptions`파라미터가 nil이 아닐 때 유효합니다.
  ///   - infoPlist: Target에서 설정할 infoPlist
  ///   - resources: 리소스 사용 경로, 기본값은 nil입니다. 만약 사용하고 싶다면 경로를 지정해주세요.
  ///   - settings: Target settings configuration
  static func custom(
    name: String,
    product: Product,
    testingOptions: Set<TestingOption> = [],
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    infoPlist: [String: Plist.Value] = [:],
    resources: ResourceFileElements? = nil,
    settings: Settings? = nil
  ) -> [Target] {
    
    let mergedInfoPlist: [String: Plist.Value] = ["BaseURL": "$(BASE_URL)"].merging(infoPlist) { _, new in
      new
    }

    var targets: [Target] = [
      Target(
        name: "\(name)",
        platform: .iOS,
        product: product,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)",
        deploymentTarget: ProjectEnvironment.default.deploymentTarget,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: resources,
        scripts: [.swiftFormat, .swiftLint],
        dependencies: dependencies,
        settings: settings
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target(
          name: "\(name)Tests",
          platform: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)FeatureTests",
          sources: "Tests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: name)]
        )
      )
    }

    if testingOptions.contains(.uiTest) {
      targets.append(
        Target(
          name: "\(name)UITests",
          platform: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)FeatureUITests",
          sources: "UITests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: name)]
        )
      )
    }

    return targets
  }
}
