//
//  OnboardingImageLoadUseCase.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - OnboardingPropertyLoadUseCaseRepresentable

public protocol OnboardingPropertyLoadUseCaseRepresentable {
  func loadOnboardingMapAuthProperty() -> OnboardingScenePropertyResponseDTO?
  func loadOnboardingHealthAuthProperty() -> OnboardingScenePropertyResponseDTO?
}

// MARK: - OnboardingImageLoadUseCase

public struct OnboardingPropertyLoadUseCase: OnboardingPropertyLoadUseCaseRepresentable {
  private let repository: OnboardingPropertyLoadRepositoryRepresentable
  private var onboardingImageDataByType: [OnboardingImageType: OnboardingScenePropertyResponseDTO] = [:]

  public init(repository: OnboardingPropertyLoadRepositoryRepresentable) {
    self.repository = repository

    loadOnboardingImage()
  }

  public func loadOnboardingMapAuthProperty() -> OnboardingScenePropertyResponseDTO? {
    return onboardingImageDataByType[.map]
  }

  public func loadOnboardingHealthAuthProperty() -> OnboardingScenePropertyResponseDTO? {
    return onboardingImageDataByType[.health]
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
