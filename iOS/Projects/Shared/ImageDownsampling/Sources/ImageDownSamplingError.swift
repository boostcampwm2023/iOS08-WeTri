//
//  ImageDownSamplingError.swift
//  ImageDownsampling
//
//  Created by 안종표 on 12/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - ImageDownsamplingError

public enum ImageDownsamplingError: Error {
  case failImageSource
  case failThumbnailImage
}
