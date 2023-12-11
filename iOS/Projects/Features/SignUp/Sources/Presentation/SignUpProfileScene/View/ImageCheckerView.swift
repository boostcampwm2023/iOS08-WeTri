//
//  ImageCheckerView.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

final class ImageCheckerView: CheckerView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func configureEnabled() {
    super.configureEnabled()
    label.text = "이미지를 추가하셨습니다."
  }

  override func configureDisabled() {
    super.configureDisabled()
    label.text = "이미지를 추가해주세요."
  }
}
