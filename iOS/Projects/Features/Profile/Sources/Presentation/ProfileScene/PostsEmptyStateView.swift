//
//  PostsEmptyStateView.swift
//  ProfileFeature
//
//  Created by 홍승현 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

final class PostsEmptyStateView: UICollectionReusableView {
  // MARK: UI Components

  private let emptyImageView: UIImageView = {
    let imageView = UIImageView(image: .noResultsImage)
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "아직 게시글을 올리지 못했네요.\n운동하고 글을 올려주세요."
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .headline)
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let profileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 33
    return stackView
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
    for view in [emptyImageView, descriptionLabel] {
      profileStackView.addArrangedSubview(view)
    }
  }

  private func setupConstraints() {
    emptyImageView.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    profileStackView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        profileStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        profileStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

        emptyImageView.widthAnchor.constraint(equalToConstant: Metrics.emptyStateImageViewWidth),
        emptyImageView.heightAnchor.constraint(equalToConstant: Metrics.emptyStateImageViewHeight),
      ]
    )
  }
}

// MARK: ProfileHeaderView.Metrics

private extension PostsEmptyStateView {
  enum Metrics {
    static let emptyStateImageViewWidth: CGFloat = 350
    static let emptyStateImageViewHeight: CGFloat = 285
  }
}
