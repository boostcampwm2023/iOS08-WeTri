//
//  OnboardingPropertyLoadUseCase.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - OnboardingPropertyLoadUseCaseRepresentable

public protocol OnboardingPropertyLoadUseCaseRepresentable {
  func loadOnboardingMapAuthProperty() -> OnboardingScenePropertyResponse?
  func loadOnboardingHealthAuthProperty() -> OnboardingScenePropertyResponse?
}

// MARK: - OnboardingPropertyLoadUseCase

public struct OnboardingPropertyLoadUseCase: OnboardingPropertyLoadUseCaseRepresentable {
  private let repository: OnboardingPropertyLoadRepositoryRepresentable
  private var onboardingImageDataByType: [OnboardingImageType: OnboardingScenePropertyResponse] = [:]

  public init(repository: OnboardingPropertyLoadRepositoryRepresentable) {
    self.repository = repository

    loadOnboardingImage()
  }

  public func loadOnboardingMapAuthProperty() -> OnboardingScenePropertyResponse? {
    return onboardingImageDataByType[.map]
  }

  public func loadOnboardingHealthAuthProperty() -> OnboardingScenePropertyResponse? {
    return onboardingImageDataByType[.health]
  }

  private mutating func loadOnboardingImage() {
    onboardingImageDataByType[.health] = repository.healthOnboardingProperty()
    onboardingImageDataByType[.map] = repository.mapOnboardingProperty()
  }

  private enum OnboardingImageType {
    case health
    case map
  }
}
