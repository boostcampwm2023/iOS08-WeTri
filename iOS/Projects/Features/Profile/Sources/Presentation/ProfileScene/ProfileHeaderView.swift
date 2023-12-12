//
//  ProfileHeaderView.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import Log
import UIKit

// MARK: - ProfileHeaderView

final class ProfileHeaderView: UICollectionReusableView {
  // MARK: UI Components

  private let profileImageView: UIImageView = {
    let imageView = UIImageView(image: .init(systemName: "person.fill"))
    imageView.contentMode = .scaleAspectFill
    imageView.tintColor = DesignSystemColor.main03 // 기본 이미지에 메인 색상을 적용하기 위함
    imageView.backgroundColor = DesignSystemColor.gray01
    imageView.layer.borderWidth = 2
    imageView.layer.cornerRadius = Metrics.profileSize * 0.5
    imageView.layer.borderColor = DesignSystemColor.main03.cgColor
    imageView.clipsToBounds = true
    return imageView
  }()

  private let nicknameLabel: UILabel = {
    let label = UILabel()
    label.text = "..."
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let profileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.spacing = 12
    return stackView
  }()

  private let postSectionLabel: UILabel = {
    let label = UILabel()
    label.text = "내 게시물"
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title2, weight: .medium)
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

  // MARK: - Configurations

  private func setupLayouts() {
    addSubview(profileStackView)
    addSubview(postSectionLabel)
    for view in [profileImageView, nicknameLabel] {
      profileStackView.addArrangedSubview(view)
    }
  }

  private func setupConstraints() {
    profileStackView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    postSectionLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        profileStackView.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.profileStackViewTop),
        profileStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.horizontal),

        profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileSize),
        profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileSize),

        postSectionLabel.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: Metrics.postSectionLabelTop),
        postSectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.horizontal),
        postSectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.postSectionLabelBottom),
      ]
    )
  }

  func configure(with model: Profile) {
    DispatchQueue.main.async {
      self.profileImageView.image = .init(data: model.profileData)
      self.nicknameLabel.text = model.nickname
    }
  }
}

// MARK: ProfileHeaderView.Metrics

private extension ProfileHeaderView {
  enum Metrics {
    static let profileSize: CGFloat = 60
    static let profileStackViewTop: CGFloat = 18
    static let horizontal: CGFloat = 24

    static let postSectionLabelTop: CGFloat = 30
    static let postSectionLabelBottom: CGFloat = 18
  }
}
