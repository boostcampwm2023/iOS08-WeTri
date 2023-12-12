//
//  CheckerView.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - CheckerView

class CheckerView: UIView {
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "exclamationmark.bubble")
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = DesignSystemColor.error
    return imageView
  }()

  let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = DesignSystemColor.error
    label.font = .systemFont(ofSize: 12)
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    configureDisabled()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureEnabled() {
    label.textColor = DesignSystemColor.main03
    imageView.image = UIImage(systemName: "checkmark.bubble")
    imageView.tintColor = DesignSystemColor.main03
  }

  func configureDisabled() {
    label.textColor = DesignSystemColor.error
    imageView.image = UIImage(systemName: "exclamationmark.bubble")
    imageView.tintColor = DesignSystemColor.error
  }
}

private extension CheckerView {
  func configureUI() {
    backgroundColor = DesignSystemColor.secondaryBackground

    addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.widthAnchor.constraint(equalToConstant: Metrics.imageSize),
      imageView.heightAnchor.constraint(equalToConstant: Metrics.imageSize),
    ])

    addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Metrics.componentInterval),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
    ])
  }
}

// MARK: - Metrics

private enum Metrics {
  static let imageSize: CGFloat = 18
  static let componentInterval: CGFloat = 4
}
