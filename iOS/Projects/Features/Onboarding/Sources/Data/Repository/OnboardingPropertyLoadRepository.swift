//
//  OnboardingPropertyLoadRepository.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation
import Trinet

// MARK: - OnboardingPropertyLoadRepository

public struct OnboardingPropertyLoadRepository {
  let decoder = JSONDecoder()
  public init() {}
}

// MARK: OnboardingPropertyLoadRepositoryRepresentable

extension OnboardingPropertyLoadRepository: OnboardingPropertyLoadRepositoryRepresentable {
  public func mapOnboardingProperty() -> OnboardingScenePropertyResponse? {
    guard
      let imagePath = Bundle(identifier: Constants.bundleName)?
      .path(forResource: Constants.mapImageResourceFileName, ofType: Constants.imageOfType),
      let imageData = try? Data(contentsOf: URL(filePath: imagePath)),

      let jsonPath = Bundle(identifier: Constants.bundleName)?
      .path(forResource: Constants.mapPropertyJsonFileName, ofType: Constants.textOfType),
      let jsonData = try? Data(contentsOf: URL(filePath: jsonPath))
    else {
      return nil
    }

    var dto = try? JSONDecoder().decode(GWResponse<OnboardingScenePropertyResponse>.self, from: jsonData).data
    dto?.imageData = imageData
    return dto
  }

  public func healthOnboardingProperty() -> OnboardingScenePropertyResponse? {
    guard
      let imagePath = Bundle(identifier: Constants.bundleName)?
      .path(forResource: Constants.healthOnboardingImageFileName, ofType: Constants.imageOfType),
      let imageData = try? Data(contentsOf: URL(filePath: imagePath)),

      let jsonPath = Bundle(identifier: Constants.bundleName)?
      .path(forResource: Constants.healthPropertyJsonFileName, ofType: Constants.textOfType),
      let jsonData = try? Data(contentsOf: URL(filePath: jsonPath))
    else {
      return nil
    }

    var dto = try? JSONDecoder().decode(GWResponse<OnboardingScenePropertyResponse>.self, from: jsonData).data
    dto?.imageData = imageData
    return dto
  }

  enum Constants {
    static let bundleName = "kr.codesquad.boostcamp8.OnboardingFeature"

    static let mapImageResourceFileName = "MapOnboardingImage"
    static let mapPropertyJsonFileName = "MapOnboardingPropertyText"

    static let healthOnboardingImageFileName = "HealthOnboardingImage"
    static let healthPropertyJsonFileName = "HealthOnboardingPropertyText"
    static let imageOfType = "png"
    static let textOfType = "json"
  }
}
