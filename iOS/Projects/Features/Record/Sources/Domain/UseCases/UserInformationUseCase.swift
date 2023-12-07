//
//  UserInformationUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import UserInformationManager

// MARK: - UserInformationUseCaseRepresentable

protocol UserInformationUseCaseRepresentable {
  func userNickName() -> String
  func userProfileImageData() -> Data?
  func userProfileImageURL() -> URL?
  func userProfileBirthDay() -> Date
}

// MARK: - UserInformationUseCase

/// 유저디폴트 매니저를 활용하여, 사용자의 개인정보를 가져옵니다.
struct UserInformationUseCase: UserInformationUseCaseRepresentable {
  private let manager = UserInformationManager.shared

  private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  func userNickName() -> String {
    guard
      let nameData = manager.data(.userNickName),
      let name = String(data: nameData, encoding: .utf8)
    else {
      return UserInformationDefaultsConstants.nickName
    }
    return name
  }

  func userProfileImageData() -> Data? {
    return manager.data(.userProfileImage)
  }

  func userProfileImageURL() -> URL? {
    guard
      let imageURLStringData = manager.data(.userProfileImageURL),
      let imageURLString = String(data: imageURLStringData, encoding: .utf8),
      let imageURL = URL(string: imageURLString)
    else {
      return UserInformationDefaultsConstants.url
    }
    return imageURL
  }

  func userProfileBirthDay() -> Date {
    guard
      let birthdayDateStringData = manager.data(.birthDayDate),
      let birthdayDateString = String(data: birthdayDateStringData, encoding: .utf8),
      let birthdayDate = formatter.date(from: birthdayDateString)
    else {
      return UserInformationDefaultsConstants.date
    }

    return birthdayDate
  }

  private enum UserInformationDefaultsConstants {
    static let nickName = "김무디"
    static let url = URL(string: "http://www.catster.com/wp-content/uploads/2017/08/Pixiebob-cat.jpg")
    static let date = Date.now
  }
}
