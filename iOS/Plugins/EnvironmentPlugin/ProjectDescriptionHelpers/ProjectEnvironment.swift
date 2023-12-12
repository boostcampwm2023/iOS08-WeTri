//
//  ProjectEnvironment.swift
//  DependencyPlugin
//
//  Created by 홍승현 on 11/20/23.
//

import ProjectDescription

public struct ProjectEnvironment {
  public let appName: String
  public let targetName: String
  public let prefixBundleID: String
  public let deploymentTarget: DeploymentTarget
  public let baseSetting: SettingsDictionary

  private init(appName: String, targetName: String, prefixBundleID: String, deploymentTarget: DeploymentTarget, baseSetting: SettingsDictionary) {
    self.appName = appName
    self.targetName = targetName
    self.prefixBundleID = prefixBundleID
    self.deploymentTarget = deploymentTarget
    self.baseSetting = baseSetting
  }

  public static var `default`: ProjectEnvironment {
    ProjectEnvironment(
      appName: "WeTri",
      targetName: "WeTri",
      prefixBundleID: "kr.codesquad.boostcamp8",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      baseSetting: [:]
    )
  }
}
