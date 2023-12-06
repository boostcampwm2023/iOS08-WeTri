//
//  ProfilePostCell.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

final class ProfilePostCell: UICollectionViewCell {
  // MARK: UI Components

  private let imageView: UIImageView = {
    let imageView = UIImageView(image: .logoImage)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  // MARK: Initializations

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }

  // MARK: - Configurations

  private func setupViews() {
    contentView.backgroundColor = DesignSystemColor.secondaryBackground
    contentView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ]
    )
  }

  func configure(with model: Post) {
    DispatchQueue.global().async {
      guard let data = try? Data(contentsOf: model.postURL) else { return }
      DispatchQueue.main.async { [weak self] in
        self?.imageView.image = UIImage(data: data)
      }
    }
  }
}
