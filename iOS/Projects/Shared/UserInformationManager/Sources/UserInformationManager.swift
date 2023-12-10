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

  public enum UserInformation: String, CaseIterable {
    case userNickName = "UserNickName"
    case userProfileImage = "UserProfileImage"
    case birthDayDate = "BirthDayDate"
    case userProfileImageURL = "UserProfileImageURL"
  }
}

public extension UserInformationManager {
  /// UserDefaults에 있는 데이터를 리턴합니다.
  ///
  /// 중요: birthDayDate의 경우 yyyy-MM-dd의 포멧을 사용하는 String의 Data를 리턴합니다.
  func data(_ key: UserInformation) -> Data? {
    return defaults.data(forKey: key.rawValue)
  }

  func setUserName(_ name: String) {
    let nameData = Data(name.utf8)
    defaults.setValue(nameData, forKey: UserInformation.userNickName.rawValue)
  }

  func setUserProfileImageData(url: URL?) {
    guard let url else {
      return
    }

    DispatchQueue.global().async { [weak self] in
      guard let data = try? Data(contentsOf: url) else {
        return
      }
      self?.setUserProfileImageData(data)
    }
  }

  func setUserProfileImageData(_ imageData: Data) {
    defaults.setValue(imageData, forKey: UserInformation.userProfileImage.rawValue)
  }

  func setBirthDayDate(_ date: Date?) {
    let date = date ?? .now
    let dateString = dateFormatter.string(from: date)
    let data = Data(dateString.utf8)
    defaults.setValue(data, forKey: UserInformation.birthDayDate.rawValue)
  }

  func setUserProfileImageURLString(url: URL?) {
    guard let urlString = url?.absoluteString else {
      return
    }
    let data = Data(urlString.utf8)
    defaults.setValue(data, forKey: UserInformation.userProfileImageURL.rawValue)
  }
}

/// Defaults이미지를 저장합니다.
private extension UserInformationManager {
  /// 만약 userDefaults에 값이 존재하지 않는다면 fakeData를 설정합니다.
  func setDefaultsData() {
    if
      data(.userNickName) != nil ||
      data(.birthDayDate) != nil ||
      data(.userProfileImage) != nil ||
      data(.userProfileImageURL) != nil {
      return
    }

    let date = Date.now
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    let dateData = Data(dateString.utf8)
    defaults.setValue(dateData, forKey: UserInformation.birthDayDate.rawValue)

    let name = Data("슈퍼맨".utf8)
    defaults.setValue(name, forKey: UserInformation.userNickName.rawValue)

    let url = URL(string: "https://www.catster.com/wp-content/uploads/2017/08/Pixiebob-cat.jpg")
    setUserProfileImageURLString(url: url)

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
