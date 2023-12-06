//
//  ImageForm.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - ImageForm

struct ImageForm {
  let imageName: String
  let imageURL: String
}

// MARK: Codable

extension ImageForm: Codable {
  enum CodingKeys: String, CodingKey {
    case imageName
    case imageURL = "imageUrl"
  }
}
