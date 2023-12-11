//
//  ProfileSettingsRepository.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import UserInformationManager

struct ProfileSettingsRepository: ProfileSettingsRepositoryRepresentable {
  private let persistency: UserInformationManager

  init(persistency: UserInformationManager) {
    self.persistency = persistency
  }
}
