//
//  Path+relativeTo.swift
//  DependencyPlugin
//
//  Created by 홍승현 on 11/19/23.
//

import ProjectDescription

public extension Path {
  static func relativeToFeature(_ path: String) -> Path {
    .relativeToRoot("Projects/Feature/\(path)")
  }

  static func relativeToApp(_ path: String) -> Path {
    .relativeToRoot("Projects/App/\(path)")
  }

  static func relativeToCore(_ path: String) -> Path {
    .relativeToRoot("Projects/Core/\(path)")
  }

  static func relativeToShared(_ path: String) -> Path {
    .relativeToRoot("Projects/Shared/\(path)")
  }

  static func relativeToXCConfig(_ path: String = "Shared") -> Path {
    .relativeToRoot("XCConfig/\(path).xcconfig")
  }
}
