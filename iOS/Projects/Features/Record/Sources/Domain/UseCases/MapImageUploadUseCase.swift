//
//  MapImageUploadUseCase.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

struct MapImageUploadUseCase: MapImageUploadUseCaseRepresentable {
  private let repository: MapImageUploadRepositoryRepresentable

  init(repository: MapImageUploadRepositoryRepresentable) {
    self.repository = repository
  }

  func uploadImage(included data: Data?) -> AnyPublisher<URL?, Never> {
    guard let data
    else {
      return Just(nil).eraseToAnyPublisher()
    }
    return repository.upload(with: data)
      .map { $0 }
      .catch { _ in Just(nil) }
      .eraseToAnyPublisher()
  }
}
