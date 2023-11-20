//
//  UIButtonConfiguration+MainCircular.swift
//  DesignSystem
//
//  Created by 홍승현 on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - Main Circular Button Configuration

public extension UIButton.Configuration {
  // MARK: UIButton.Configuration

  static func mainCircularEnabled(title: String) -> UIButton.Configuration {
    var plainConfiguration = Self.plain()

    var backgroundConfiguration = plainConfiguration.background
    backgroundConfiguration.backgroundColor = .main03
    plainConfiguration.background = backgroundConfiguration

    plainConfiguration.titleAlignment = .center
    plainConfiguration.cornerStyle = .capsule
    plainConfiguration.baseForegroundColor = .secondaryBackground
    plainConfiguration.title = title

    return plainConfiguration
  }

  static func mainCircularDisabled(title: String) -> UIButton.Configuration {
    var plainConfiguration = Self.plain()

    var backgroundConfiguration = plainConfiguration.background
    backgroundConfiguration.backgroundColor = .gray03
    plainConfiguration.background = backgroundConfiguration

    plainConfiguration.titleAlignment = .center
    plainConfiguration.cornerStyle = .capsule
    plainConfiguration.baseForegroundColor = .secondaryBackground
    plainConfiguration.title = title

    return plainConfiguration
  }

  static func mainCircularSelected(title: String) -> UIButton.Configuration {
    var plainConfiguration = Self.plain()

    var backgroundConfiguration = plainConfiguration.background
    backgroundConfiguration.backgroundColor = .main02
    plainConfiguration.background = backgroundConfiguration

    plainConfiguration.titleAlignment = .center
    plainConfiguration.cornerStyle = .capsule
    plainConfiguration.baseForegroundColor = .secondaryBackground
    plainConfiguration.title = title

    return plainConfiguration
  }

  // MARK: - ConfigurationUpdateHandler

  static func mainCircular(label text: String) -> UIButton.ConfigurationUpdateHandler {
    return { button in
      switch button.state {
      case .normal:
        button.configuration = .mainCircularEnabled(title: text)
      case .selected:
        button.configuration = .mainCircularSelected(title: text)
      case .disabled:
        button.configuration = .mainCircularDisabled(title: text)
      default: break
      }
      button.configuration?.title = text
      button.configuration?.font = .preferredFont(forTextStyle: .largeTitle, with: .traitBold)
    }
  }
}
