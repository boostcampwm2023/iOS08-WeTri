//
//  SignUpUserDefaultsManagerUseCase.swift
//  SignUpFeature
//
//  Created by MaraMincho on 12/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import UserInformationManager

// MARK: - SignUpUserDefaultsManagerUseCaseRepresentable

public protocol SignUpUserDefaultsManagerUseCaseRepresentable {
  func setSignUpUserInformationAtUserDefaults(_ signUpUserInformation: SignUpUser)
}

// MARK: - SignUpUserDefaultsManagerUseCase

public struct SignUpUserDefaultsManagerUseCase: SignUpUserDefaultsManagerUseCaseRepresentable {
  let manager = UserInformationManager.shared
  public func setSignUpUserInformationAtUserDefaults(_ signUpUserInformation: SignUpUser) {
    // UserDefaults에 nickName을 저장합니다.
    manager.setUserName(signUpUserInformation.nickname)

    // UserDefaults에 ProfileImage URL을 저장합니다.
    manager.setUserProfileImageURLString(url: signUpUserInformation.profileImage)

    // UserDefaults에 ProfileImage Data를 저장합니다.
    manager.setUserProfileImageData(url: signUpUserInformation.profileImage)

    // UserDefaults에 생년 월일을 저장합니다.
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.date(from: signUpUserInformation.birthDate)
    manager.setBirthDayDate(date)
  }
}
