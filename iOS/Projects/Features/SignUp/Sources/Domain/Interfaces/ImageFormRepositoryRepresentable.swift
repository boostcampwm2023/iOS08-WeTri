//
//  ImageFormRepositoryRepresentable.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

protocol ImageFormRepositoryRepresentable {
  func send(imageData: Data) -> String
}
