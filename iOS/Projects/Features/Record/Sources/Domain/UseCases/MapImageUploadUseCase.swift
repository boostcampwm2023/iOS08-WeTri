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

  func uploadImage(included data: Data?) -> AnyPublisher<URL, Error> {
    guard let data else {
      return Empty<URL, Error>().eraseToAnyPublisher()
    }
    return repository.upload(with: data)
  }
}
