//
//  UserDefaultsManager.swift
//  UserDefaultsManager
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation


public final class UserDefaultsManager {
  public static let shared = UserDefaultsManager()
  
  private init () {}
  
  private let defaults = UserDefaults.standard
  
  func loadUserName() -> String? {
    return defaults.string(forKey: UserDefaultsKeys.userName)
  }
  
  func loadUserImageData() -> Data? {
    return defaults.data(forKey: UserDefaultsKeys.userImage)
  }
  
  func loadBirthDayDateString() -> String? {
    return defaults.string(forKey: UserDefaultsKeys.birthDayDate)
  }
  
  private enum UserDefaultsKeys {
    static let userName: String = "UserNickName"
    static let userImage: String = "UserProfileImage"
    static let birthDayDate: String = "BirthDatDate"
  }
}
