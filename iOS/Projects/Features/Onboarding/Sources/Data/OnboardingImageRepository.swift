//
//  OnboardingImageRepository.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - OnboardingImageRepository

struct OnboardingImageRepository {
  init() {}
}

// MARK: OnboardingImageRepositoryRepresentable

extension OnboardingImageRepository: OnboardingImageRepositoryRepresentable {
  func mapOnboardingImage() -> Data? {
    return Bundle(identifier: Constants.bundleName)?.path(forResource: Constants.mapImageResourceFileName, ofType: Constants.ofType) as? Data
  }

  func healthOnboardingImage() -> Data? {
    return Bundle(identifier: Constants.bundleName)?.path(forResource: Constants.healthOnboardingImageFileName, ofType: Constants.ofType) as? Data
  }

  enum Constants {
    static let bundleName = "kr.codesquad.boostcamp8.OnboardingFeature"

    static let mapImageResourceFileName = "MapOnboardingImage"
    static let healthOnboardingImageFileName = "HealthOnboardingImage"

    static let ofType = "png"
  }
}
