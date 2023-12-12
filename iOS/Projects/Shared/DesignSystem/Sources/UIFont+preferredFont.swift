//
//  UIFont+preferredFont.swift
//  DesignSystem
//
//  Created by 홍승현 on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

public extension UIFont {
  @available(*, deprecated, renamed: "preferredFont(forTextStyle:weight:)", message: "Weight를 설정할 수 있는 함수로 변경해주세요.")
  static func preferredFont(forTextStyle: TextStyle, with traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    let font = Self.preferredFont(forTextStyle: forTextStyle)
    guard let descriptor = font.fontDescriptor.withSymbolicTraits(traits) else {
      return font
    }

    return UIFont(descriptor: descriptor, size: 0)
  }

  /// 텍스트 스타일과 굵기에 맞는 Font를 반환합니다.
  ///
  /// - Parameters:
  ///   - textStyle: 사용할 텍스트 스타일. `.body`, `.headline`, `.subheadline` 등이 있습니다.
  ///   - weight: 폰트 굵기. `UIFont.Weight` 열거형을 사용합니다. `.regular`, `.bold` 등이 있습니다.
  ///             이 파라미터는 Optional이며, 제공하지 않는다면 시스템 기본값을 사용합니다.
  ///
  /// - Returns: 지정한 스타일과 굵기에 맞는 `UIFont` 객체를 반환합니다.
  static func preferredFont(forTextStyle textStyle: TextStyle, weight: UIFont.Weight?) -> UIFont {
    let descriptor = UIFontDescriptor
      .preferredFontDescriptor(withTextStyle: textStyle)
      .addingAttributes(
        [
          .traits: [UIFontDescriptor.TraitKey.weight: weight],
        ]
      )
    return UIFont(descriptor: descriptor, size: 0)
  }
}
