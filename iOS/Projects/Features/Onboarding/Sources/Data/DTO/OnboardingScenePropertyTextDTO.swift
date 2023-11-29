//
//  OnboardingScenePropertyTextDTO.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct OnboardingScenePropertyTextDTO {
  let id: Int
  let titleText: String
  let descriptionText: String

  init(id: Int, titleText: String, descriptionText: String) {
    self.id = id
    self.titleText = titleText
    self.descriptionText = descriptionText
  }

  func toOnboardingScenePropertyDTO(imageData: Data?) -> OnboardingScenePropertyDTO {
    return .init(id: id, titleText: titleText, descriptionText: descriptionText, imageData: imageData)
  }
}
