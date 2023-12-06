//
//  UserInformationManager.swift
//  UserInformationManager
//
//  Created by MaraMincho on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - UserInformationManager

public final class UserInformationManager {
  public static let shared = UserInformationManager()

  private init() {
    setDefaultsData()
  }

  private let defaults = UserDefaults.standard
  private let dateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  /// Memory Cache에 있는 데이터를 리턴합니다.
  ///
  /// 중요: birthDayDate의 경우 yyyy-MM-dd의 포멧을 사용하는 String의 Data를 리턴합니다.
  func data(_ key: UserInformation) -> Data? {
    return defaults.data(forKey: key.rawValue)
  }

  public enum UserInformation: String, CaseIterable {
    case userName = "UserNickName"
    case userProfileImage = "UserProfileImage"
    case birthDayDate = "BirthDayDate"
    case userProfileImageURL = "UserImageURL"
  }
}

public extension UserInformationManager {
  func setUserName(_ name: String) {
    let nameData = Data(name.utf8)
    defaults.setValue(nameData, forKey: UserInformation.userName.rawValue)
  }

  func setUserProfileImageData(_ imageData: Data) {
    defaults.setValue(imageData, forKey: UserInformation.userName.rawValue)
  }

  func setBirthDayDate(_ date: Date) {
    let dateString = dateFormatter.string(from: date)
    let data = Data(dateString.utf8)
    defaults.setValue(data, forKey: UserInformation.birthDayDate.rawValue)
  }
}

/// Defaults이미지를 저장합니다.
private extension UserInformationManager {
  /// 만약 userDefaults에 값이 존재한다면 fakeData를 설정합니다.
  func setDefaultsData() {
    guard
      data(.userName) == nil,
      data(.birthDayDate) == nil,
      data(.userProfileImage) == nil,
      data(.userProfileImageURL) == nil
    else {
      return
    }

    let date = Date.now
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    let dateData = Data(dateString.utf8)
    defaults.setValue(dateData, forKey: UserInformation.birthDayDate.rawValue)

    let name = Data("김무드".utf8)
    defaults.setValue(name, forKey: UserInformation.userName.rawValue)

    guard let imageURL = URL(string: "https://www.catster.com/wp-content/uploads/2017/08/Pixiebob-cat.jpg") else {
      return
    }
    defaults.setValue(imageURL, forKey: UserInformation.userProfileImageURL.rawValue)

    guard
      let path = Bundle(for: Self.self).path(forResource: DefaultsKey.imageKey, ofType: DefaultsKey.imageType),
      let imageData = try? Data(contentsOf: URL(filePath: path))
    else {
      return
    }
    defaults.setValue(imageData, forKey: UserInformation.userProfileImage.rawValue)
  }

  private enum DefaultsKey {
    static let imageKey = "DefaultsProfileImage"
    static let imageType = "png"
  }
}
