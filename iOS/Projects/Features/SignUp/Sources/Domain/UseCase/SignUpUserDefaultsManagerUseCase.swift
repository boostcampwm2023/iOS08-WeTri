//
//  SignUpUserDefaultsManager.swift
//  SignUpFeature
//
//  Created by MaraMincho on 12/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation


protocol SignUpUserDefaultsManagerUseCaseRepresentable {
  func setSignUpUserInformation(signUpUser: SignUpUser)
}

struct SignUpUserDefaultsManagerUseCase {
  func setSignUpUserInformationAtUserDefaults(_ signUpUser: SignUpUser) {
    
  }
}
