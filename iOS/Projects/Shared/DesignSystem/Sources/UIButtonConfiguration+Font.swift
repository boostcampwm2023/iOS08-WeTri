//
//  UIButtonConfiguration+Font.swift
//  DesignSystem
//
//  Created by 홍승현 on 11/14/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

public extension UIButton.Configuration {
  var font: UIFont? {
    get {
      attributedTitle?.font
    }
    set {
      attributedTitle?.font = newValue
    }
  }
}
