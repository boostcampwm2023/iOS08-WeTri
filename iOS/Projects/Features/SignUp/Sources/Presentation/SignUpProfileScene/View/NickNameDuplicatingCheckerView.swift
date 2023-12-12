//
//  NickNameDuplicatingCheckerView.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

final class NickNameDuplicatingCheckerView: CheckerView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func configureEnabled() {
    super.configureEnabled()
    label.text = "닉네임이 중복되지 않았습니다."
  }

  override func configureDisabled() {
    super.configureDisabled()
    label.text = "닉네임이 중복되었습니다."
  }
}
