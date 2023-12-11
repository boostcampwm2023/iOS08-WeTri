//
//  ProfileSettingsRepository.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import UserInformationManager

// MARK: - ProfileSettingsRepository

struct ProfileSettingsRepository: ProfileSettingsRepositoryRepresentable {
  private let persistency: UserInformationManager

  init(persistency: UserInformationManager) {
    self.persistency = persistency
  }

  func userInformation() throws -> Profile {
    guard
      let profileImageData = persistency.data(.userProfileImage),
      let nicknameData = persistency.data(.userNickName),
      let birthData = persistency.data(.birthDayDate),
      let nickname = String(data: nicknameData, encoding: .utf8),
      let birth = String(data: birthData, encoding: .utf8)
    else {
      throw ProfileSettingsRepositoryError.retrievalError
    }
    return .init(profileData: profileImageData, nickname: nickname, birth: birth)
  }
}

// MARK: - ProfileSettingsRepositoryError

private enum ProfileSettingsRepositoryError: Error {
  case retrievalError
}
