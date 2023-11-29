//
//  OnboardingImageRepository.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - OnboardingImageRepository

public struct OnboardingImageRepository {
  let decoder = JSONDecoder()
  public init() {}
}

// MARK: OnboardingImageRepositoryRepresentable

extension OnboardingImageRepository: OnboardingImageRepositoryRepresentable {
  public func mapOnboardingProperty() -> OnboardingScenePropertyDTO? {
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
    let dto = try? JSONDecoder().decode(GWResponse<OnboardingScenePropertyTextDTO>.self, from: jsonData).data
    return dto?.toOnboardingScenePropertyDTO(imageData: imageData)
  }

  public func healthOnboardingImage() -> OnboardingScenePropertyDTO? {
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
    let dto = try? JSONDecoder().decode(GWResponse<OnboardingScenePropertyTextDTO>.self, from: jsonData).data
    return dto?.toOnboardingScenePropertyDTO(imageData: imageData)
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
