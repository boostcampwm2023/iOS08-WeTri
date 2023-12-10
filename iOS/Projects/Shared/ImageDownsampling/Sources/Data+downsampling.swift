//
//  Data+downsampling.swift
//  ImageDownsampling
//
//  Created by 안종표 on 12/10/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

public extension Data {
  func downsampling(size: CGSize, scale: Scale) throws -> UIImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithData(
      self as CFData,
      imageSourceOptions
    )
    else {
      throw ImageDownsamplingError.failImageSource
    }
    let thumbnailMaxPixelSize = Swift.max(size.width, size.height) * scale.rawValue
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: thumbnailMaxPixelSize,
    ] as CFDictionary

    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
      throw ImageDownsamplingError.failThumbnailImage
    }
    return UIImage(cgImage: downsampledImage)
  }
}
