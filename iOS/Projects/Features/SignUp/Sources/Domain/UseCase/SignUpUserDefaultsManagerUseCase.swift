//
//  SignUpUserDefaultsManager.swift
//  SignUpFeature
//
//  Created by MaraMincho on 12/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import UserInformationManager


protocol SignUpUserDefaultsManagerUseCaseRepresentable {
  func setSignUpUserInformation(signUpUser: SignUpUser)
}

struct SignUpUserDefaultsManagerUseCase {
  let manager = UserInformationManager.shared
  func setSignUpUserInformationAtUserDefaults(_ signUpUserInformation: SignUpUser) {
    manager.setUserName(signUpUserInformation.birthDate)
    manager.setUserProfileImageURLString(url: signUpUserInformation.profileImage)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.date(from: signUpUserInformation.birthDate)
    manager.setBirthDayDate(date)
    
  }
}
