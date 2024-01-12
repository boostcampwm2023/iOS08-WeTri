//
//  FeedImageCell.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Cacher
import UIKit

// MARK: - FeedImageCell

final class FeedImageCell: UICollectionViewCell {
  static let identifier = "FeedImageCell"

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewHierarchyAndConstraints()
    backgroundColor = .white
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("cant use this init")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    feedImage.image = nil
  }

  private func setupViewHierarchyAndConstraints() {
    contentView.addSubview(feedImage)
    feedImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    feedImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    feedImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    feedImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }

  private let feedImage: UIImageView = {
    let image = UIImageView()

    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()

  func configure(imageURL: URL?) {
    guard let imageURL else {
      return
    }
    guard let data = MemoryCacheManager.shared.fetch(cacheKey: imageURL.absoluteString) else {
      DispatchQueue.global().async {
        guard let data = try? Data(contentsOf: imageURL) else { return }
        DispatchQueue.main.async { [weak self] in
          self?.feedImage.image = UIImage(data: data)
        }
      }
      return
    }
    feedImage.image = UIImage(data: data)
  }
}
