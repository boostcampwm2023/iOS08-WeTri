//
//  OnboardingImageRepositoryRepresentable.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - OnboardingImageRepositoryRepresentable

public protocol OnboardingImageRepositoryRepresentable {
  func mapOnboardingProperty() -> OnboardingScenePropertyDTO?
  func healthOnboardingImage() -> OnboardingScenePropertyDTO?
}
