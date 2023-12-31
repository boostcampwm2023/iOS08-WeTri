//
//  OnboardingScenePropertyResponse.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public struct OnboardingScenePropertyResponse: Decodable {
  let id: Int
  let titleText: String
  let descriptionText: String
  var imageData: Data?
  init(id: Int, titleText: String, descriptionText: String, imageData: Data?) {
    self.id = id
    self.titleText = titleText
    self.descriptionText = descriptionText
    self.imageData = imageData
  }
}
