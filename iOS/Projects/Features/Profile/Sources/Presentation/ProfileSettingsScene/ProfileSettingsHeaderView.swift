//
//  ProfileSettingsHeaderView.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - ProfileSettingsHeaderView

final class ProfileSettingsHeaderView: UICollectionReusableView {
  // MARK: UI Components

  private let imageView: UIImageView = {
    let imageView = UIImageView(image: .logoImage)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = Metrics.imageViewSize * 0.5
    imageView.backgroundColor = DesignSystemColor.gray01
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = DesignSystemColor.main03.cgColor
    return imageView
  }()

  private let nicknameLabel: UILabel = {
    let label = UILabel()
    label.text = "NickName"
    label.font = .preferredFont(forTextStyle: .callout)
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let birthLabel: UILabel = {
    let label = UILabel()
    label.text = "1900. 00. 00"
    label.font = .preferredFont(forTextStyle: .callout)
    label.textColor = DesignSystemColor.gray03
    return label
  }()

  // MARK: Initializations

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayouts()
    setupConstraints()
  }

  // MARK: Configurations

  private func setupLayouts() {
    addSubview(imageView)
    addSubview(nicknameLabel)
    addSubview(birthLabel)
  }

  private func setupConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
    birthLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.imageViewTop),
        imageView.widthAnchor.constraint(equalToConstant: Metrics.imageViewSize),
        imageView.heightAnchor.constraint(equalToConstant: Metrics.imageViewSize),
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

        nicknameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        nicknameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Metrics.nicknameLabelTop),

        birthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        birthLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: Metrics.birthLabelTop),
        birthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.birthLabelBottom),
      ]
    )
  }
}

// MARK: ProfileSettingsHeaderView.Metrics

private extension ProfileSettingsHeaderView {
  enum Metrics {
    static let imageViewSize: CGFloat = 80

    static let imageViewTop: CGFloat = 24
    static let nicknameLabelTop: CGFloat = 16
    static let birthLabelTop: CGFloat = 8
    static let birthLabelBottom: CGFloat = 24
  }
}
