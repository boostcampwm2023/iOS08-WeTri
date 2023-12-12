//
//  NickNameCheckerView.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

final class NickNameCheckerView: CheckerView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    label.text = "글자수는 2~20자, 특수문자는 사용할 수 없어요."
  }

  override func configureEnabled() {
    super.configureEnabled()
    label.text = "사용가능한 닉네임이에요."
  }

  override func configureDisabled() {
    super.configureDisabled()
    label.text = "글자수는 2~20자, 특수문자는 사용할 수 없어요."
  }
}
