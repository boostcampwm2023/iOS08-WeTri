//
//  ProfileSettingsUseCase.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/11/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct ProfileSettingsUseCase: ProfileSettingsUseCaseRepresentable {
  private let repository: ProfileSettingsRepositoryRepresentable

  init(repository: ProfileSettingsRepositoryRepresentable) {
    self.repository = repository
  }

  func userInformation() throws -> Profile {
    return try repository.userInformation()
  }
}
