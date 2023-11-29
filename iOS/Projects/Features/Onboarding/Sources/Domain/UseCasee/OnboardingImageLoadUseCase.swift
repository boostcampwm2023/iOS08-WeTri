//
//  OnboardingImageLoadUseCase.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - OnboardingImageLoadUseCaseRepresentable

public protocol OnboardingImageLoadUseCaseRepresentable {
  func mapOnboardingImage() -> OnboardingScenePropertyDTO?
  func healthOnboardingImage() -> OnboardingScenePropertyDTO?
}

// MARK: - OnboardingImageLoadUseCase

public struct OnboardingImageLoadUseCase: OnboardingImageLoadUseCaseRepresentable {
  private let repository: OnboardingImageRepositoryRepresentable
  private var onboardingImageDataByType: [OnboardingImageType: OnboardingScenePropertyDTO] = [:]

  public init(repository: OnboardingImageRepositoryRepresentable) {
    self.repository = repository

    loadOnboardingImage()
  }

  public func mapOnboardingImage() -> OnboardingScenePropertyDTO? {
    return onboardingImageDataByType[.health]
  }

  public func healthOnboardingImage() -> OnboardingScenePropertyDTO? {
    return onboardingImageDataByType[.map]
  }

  private mutating func loadOnboardingImage() {
    onboardingImageDataByType[.health] = repository.healthOnboardingImage()
    onboardingImageDataByType[.map] = repository.mapOnboardingProperty()
  }

  private enum OnboardingImageType {
    case health
    case map
  }
}
