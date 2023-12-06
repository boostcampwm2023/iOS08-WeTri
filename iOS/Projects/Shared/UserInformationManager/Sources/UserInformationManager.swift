//
//  UserInformationManager.swift
//  UserInformationManager
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Cacher
import Foundation

// MARK: - UserInformationManager

public final class UserInformationManager {
  public static let shared = UserInformationManager()

  private init() {
    setFakeData()
    setMemoryCacheUserInformation()
  }

  private let defaults = UserDefaults.standard
  private let memoryCacheManager = MemoryCacheManager.shared
  private let dateFormatter =  {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  private func setMemoryCacheUserInformation() {
    UserInformation
      .allCases
      .forEach { userInformation in
        let key = userInformation.rawValue
        guard let data = defaults.data(forKey: key) else {
          return
        }
        memoryCacheManager.set(cacheKey: key, data: data)
      }
  }

  // UserInformation에 있는 데이터를 리턴합니다.
  // birthDayDate의 경우 yyyy-MM-dd의 포멧을 사용하는 String의 Data를 리턴합니다.
  func data(_ key: UserInformation) -> Data? {
    return memoryCacheManager.fetch(cacheKey: key.rawValue)
  }

  public enum UserInformation: String, CaseIterable {
    case userName = "UserNickName"
    case userProfileImage = "UserProfileImage"
    case birthDayDate = "BirthDayDate"
  }
}

public extension UserInformationManager {
  func setBirthDayDate(_ date: Date) {
    let dateString = dateFormatter.string(from: date)
    let data = Data(dateString.utf8)
    defaults.setValue(data, forKey: UserInformation.birthDayDate.rawValue)
  }
  
  func setUserName(_ name: String) {
    let nameData = Data(name.utf8)
    defaults.setValue(nameData, forKey: UserInformation.userName.rawValue)
  }
  
  func setUserProfileImageData(_ imageData: Data) {
    defaults.setValue(imageData, forKey: UserInformation.userName.rawValue)
  }
}

import UIKit

// TODO: 토큰 연결이 완성되면 무조건 지울 예정
private extension UserInformationManager {
  func setFakeData() {
    let configure = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 45))
    let image = UIImage(systemName: "figure.run", withConfiguration: configure)!.pngData()!
    defaults.setValue(image, forKey: UserInformation.userProfileImage.rawValue)

    let date = Date.now
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    let dateData = Data(dateString.utf8)
    defaults.setValue(dateData, forKey: UserInformation.birthDayDate.rawValue)

    let name = Data("김무드".utf8)
    defaults.setValue(name, forKey: UserInformation.userName.rawValue)
  }
}
