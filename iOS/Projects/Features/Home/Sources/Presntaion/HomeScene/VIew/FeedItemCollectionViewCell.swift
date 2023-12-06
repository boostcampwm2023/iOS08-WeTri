//
//  FeedItemCollectionViewCell.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import UIKit

// MARK: - FeedItemCollectionViewCell

class FeedItemCollectionViewCell: UICollectionViewCell {
  static let identifier = "FeedItemCollectionViewCell"

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("생성할 수 없습니다.")
  }
}

extension FeedItemCollectionViewCell {
  func setup() {
    setStyle()
  }

  func setStyle() {
    backgroundColor = .red
  }
}
