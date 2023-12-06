//
//  NickNameCheckUseCase.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - NickNameCheckUseCaseRepresentable

protocol NickNameCheckUseCaseRepresentable {
  func check(nickName: String) -> Bool
}

// MARK: - NickNameCheckUseCase

struct NickNameCheckUseCase: NickNameCheckUseCaseRepresentable {
  func check(nickName: String) -> Bool {
    let regex = "^[^\\W_]{2,20}$"
    let check = NSPredicate(format: "SELF MATCHES %@", regex)
    return check.evaluate(with: nickName)
  }
}
