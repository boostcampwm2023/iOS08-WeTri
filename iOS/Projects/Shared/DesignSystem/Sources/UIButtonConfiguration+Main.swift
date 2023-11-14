//
//  UIButtonConfiguration+Main.swift
//  DesignSystem
//
//  Created by 홍승현 on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - Main Button Configuration

public extension UIButton.Configuration {
  // MARK: UIButton.Configuration

  static func mainEnabled(title: String) -> UIButton.Configuration {
    var plainConfiguration = Self.plain()

    var backgroundConfiguration = plainConfiguration.background
    backgroundConfiguration.backgroundColor = .main03
    backgroundConfiguration.cornerRadius = 8
    plainConfiguration.background = backgroundConfiguration

    plainConfiguration.titleAlignment = .center
    plainConfiguration.baseForegroundColor = .secondaryBackGround
    plainConfiguration.title = title

    return plainConfiguration
  }

  static func mainDisabled(title: String) -> UIButton.Configuration {
    var plainConfiguration = Self.plain()

    var backgroundConfiguration = plainConfiguration.background
    backgroundConfiguration.backgroundColor = .gray03
    backgroundConfiguration.cornerRadius = 8
    plainConfiguration.background = backgroundConfiguration

    plainConfiguration.titleAlignment = .center
    plainConfiguration.baseForegroundColor = .secondaryBackGround
    plainConfiguration.title = title

    return plainConfiguration
  }

  static func mainSelected(title: String) -> UIButton.Configuration {
    var plainConfiguration = Self.plain()

    var backgroundConfiguration = plainConfiguration.background
    backgroundConfiguration.backgroundColor = .main02
    backgroundConfiguration.cornerRadius = 8
    plainConfiguration.background = backgroundConfiguration

    plainConfiguration.titleAlignment = .center
    plainConfiguration.baseForegroundColor = .secondaryBackGround
    plainConfiguration.title = title

    return plainConfiguration
  }

  // MARK: - ConfigurationUpdateHandler

  static func main(label text: String) -> UIButton.ConfigurationUpdateHandler {
    return { button in
      switch button.state {
      case .normal:
        button.configuration = .mainEnabled(title: text)
      case .selected:
        button.configuration = .mainSelected(title: text)
      case .disabled:
        button.configuration = .mainDisabled(title: text)
      default: break
      }
      button.configuration?.title = text
      button.configuration?.font = .preferredFont(forTextStyle: .headline)
    }
  }
}
