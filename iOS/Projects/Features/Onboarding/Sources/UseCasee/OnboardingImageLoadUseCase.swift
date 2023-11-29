//
//  OnboardingImageLoadUseCase.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - OnboardingImageLoadUseCaseRepresentable

protocol OnboardingImageLoadUseCaseRepresentable {
  func mapOnboardingImage() -> Data?
  func healthOnboardingImage() -> Data?
}

// MARK: - OnboardingImageRepositoryRepresentable

protocol OnboardingImageRepositoryRepresentable {
  func mapOnboardingImage() -> Data?
  func healthOnboardingImage() -> Data?
}

// MARK: - OnboardingImageLoadUseCase

struct OnboardingImageLoadUseCase: OnboardingImageLoadUseCaseRepresentable {
  private let repository: OnboardingImageRepositoryRepresentable
  private var onboardingImageDataByType: [OnboardingImageType: Data] = [:]

  init(repository: OnboardingImageRepositoryRepresentable) {
    self.repository = repository

    loadOnboardingImage()
  }

  func mapOnboardingImage() -> Data? {
    return nil
  }

  func healthOnboardingImage() -> Data? {
    return nil
  }

  private mutating func loadOnboardingImage() {
    onboardingImageDataByType[.health] = repository.healthOnboardingImage()
    onboardingImageDataByType[.map] = repository.mapOnboardingImage()
  }

  private enum OnboardingImageType {
    case health
    case map
  }
}
