//
//  UIImage+downsampling.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 12/10/23.
//

import UIKit

public extension UIImage {
  func downsampling(size: CGSize, scale: Scale) throws -> UIImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let data = pngData(),
          let imageSource = CGImageSourceCreateWithData(
            data as CFData,
            imageSourceOptions
          )
    else {
      throw ImageDownsamplingError.failImageSource
    }
    let thumbnailMaxPixelSize = max(size.width, size.height) * scale.rawValue
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
