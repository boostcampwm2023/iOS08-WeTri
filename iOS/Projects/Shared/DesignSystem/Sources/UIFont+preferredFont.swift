//
//  UIFont+preferredFont.swift
//  DesignSystem
//
//  Created by 홍승현 on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

public extension UIFont {
  static func preferredFont(forTextStyle: TextStyle, with traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    let font = Self.preferredFont(forTextStyle: forTextStyle)
    guard let descriptor = font.fontDescriptor.withSymbolicTraits(traits) else {
      return font
    }

    return UIFont(descriptor: descriptor, size: 0)
  }
}
