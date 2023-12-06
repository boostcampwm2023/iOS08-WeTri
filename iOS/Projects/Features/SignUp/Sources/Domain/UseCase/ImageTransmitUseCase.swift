//
//  ImageTransmitUseCase.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log

// MARK: - ImageTransmitUseCaseRepresentable

public protocol ImageTransmitUseCaseRepresentable {
  func transmit(imageData: Data) -> AnyPublisher<[ImageForm], Error>
}

// MARK: - ImageTransmitUseCase

public final class ImageTransmitUseCase: ImageTransmitUseCaseRepresentable {
  private var subscriptions: Set<AnyCancellable> = []

  private let imageFormRepository: ImageFormRepositoryRepresentable

  public init(imageFormRepository: ImageFormRepositoryRepresentable) {
    self.imageFormRepository = imageFormRepository
  }

  public func transmit(imageData: Data) -> AnyPublisher<[ImageForm], Error> {
    return imageFormRepository.send(imageData: imageData)
      .eraseToAnyPublisher()
  }
}
