//
//  MapImageUploadRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 홍승현 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol MapImageUploadRepositoryRepresentable {
  func upload(with imageData: Data) -> AnyPublisher<URL, Error>
}
