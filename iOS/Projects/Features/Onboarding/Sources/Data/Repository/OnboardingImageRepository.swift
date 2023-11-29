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
  public init() {}
}

// MARK: OnboardingImageRepositoryRepresentable

extension OnboardingImageRepository: OnboardingImageRepositoryRepresentable {
  public func mapOnboardingProperty() -> OnboardingScenePropertyDTO? {
    let imageData = Bundle(identifier: Constants.bundleName)?.path(forResource: Constants.mapImageResourceFileName, ofType: Constants.imageOfType) as? Data

    let onboardingTextDTO = Bundle(identifier: Constants.bundleName)?.path(forResource: Constants.mapPropertyJsonFileName, ofType: Constants.textOfType) as? OnboardingScenePropertyTextDTO

    return onboardingTextDTO?.toOnboardingScenePropertyDTO(imageData: imageData)
  }

  public func healthOnboardingImage() -> OnboardingScenePropertyDTO? {
    let imageData = Bundle(identifier: Constants.bundleName)?.path(forResource: Constants.healthOnboardingImageFileName, ofType: Constants.imageOfType) as? Data

    let onboardingTextDTO = Bundle(identifier: Constants.bundleName)?.path(forResource: Constants.healthPropertyJsonFileName, ofType: Constants.textOfType) as? OnboardingScenePropertyTextDTO

    return onboardingTextDTO?.toOnboardingScenePropertyDTO(imageData: imageData)
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
