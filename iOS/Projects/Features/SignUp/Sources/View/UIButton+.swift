//
//  UIButton+.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

extension UIButton {
  func updateConfiguration(title: String) {
    if isSelected {
      configuration?.font = .preferredFont(forTextStyle: .headline, weight: .bold)
      configuration?.titleAlignment = .center
      configuration = .mainEnabled(title: title)
    } else {
      configuration?.font = .preferredFont(forTextStyle: .headline, weight: .bold)
      configuration?.titleAlignment = .center
      configuration = .mainDisabled(title: title)
    }
  }
}
