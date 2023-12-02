//
//  Logger.swift
//  DesignSystem
//
//  Created by 홍승현 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import OSLog

// MARK: - Log

/// 로그
public enum Log {
  /// Logger를 생성합니다.
  /// - Parameter category: Log를 구분하는 Category
  public static func make(with category: LogCategory = .default) -> Logger {
    return Logger(subsystem: .bundleIdentifier, category: category.rawValue)
  }
}

// MARK: - LogCategory

/// 로그 카테고리
public enum LogCategory: String {
  /// 기본값으로 들어갑니다.
  case `default`

  /// UI 로그를 작성할 때 사용합니다.
  case userInterface

  /// 네트워크 로그를 작성할 때 사용합니다.
  case network

  /// HealthKit 로그를 담당합니다.
  case healthKit

  /// Socket 로그를 담당합니다.
  case socket
}

private extension String {
  static let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? "None"
}
