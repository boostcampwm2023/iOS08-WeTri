//
//  AttachPictureCollectionViewCell.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - AttachPictureCollectionViewCell

final class AttachPictureCollectionViewCell: UICollectionViewCell {
  static let identifier = "AttachPictureCollectionViewCell"

  override init(frame _: CGRect) {
    super.init(frame: .zero)
    setup()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("이 생성자는 사용할 수 없습니다.")
  }

  private let contentImageView: UIImageView = {
    let imageView = UIImageView()

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  func configure(image: UIImage?) {
    contentImageView.image = image
  }
}

private extension AttachPictureCollectionViewCell {
  func setup() {
    setupStyle()
    makeShadowAndRounded()
    setupViewHierarchyAndConstraints()
  }

  func setupStyle() {
    backgroundView?.backgroundColor = DesignSystemColor.primaryBackground
  }

  func setupViewHierarchyAndConstraints() {
    contentView.addSubview(contentImageView)
    contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    contentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }

  func makeShadowAndRounded() {
    let radius: CGFloat = 10
    contentView.layer.cornerRadius = radius
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1.0)
    layer.shadowRadius = 2.0
    layer.shadowOpacity = 0.5
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    layer.cornerRadius = radius
  }
}
