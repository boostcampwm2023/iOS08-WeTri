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
  func uploadImage(included data: Data?) -> AnyPublisher<URL, Error> {
    return Empty<URL, Error>().eraseToAnyPublisher()
  }
}
