//
//  SessionParticipantCell.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - SessionParticipantCell

final class SessionParticipantCell: UICollectionViewCell {
  // MARK: UI Components

  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = DesignSystemColor.primaryBackground
    imageView.layer.cornerRadius = Metrics.profileImageSize * 0.5
    imageView.layer.cornerCurve = .continuous
    imageView.clipsToBounds = true
    return imageView
  }()

  private let nicknameLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3)
    label.text = "S043_홍승현"
    label.accessibilityHint = Strings.nicknameAccessibilityHint
    return label
  }()

  private let distanceLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3, with: .traitBold)
    label.text = "4.3km"
    label.accessibilityHint = Strings.workoutDistanceAccessibilityHint
    return label
  }()

  private let markingCircularContainerView: UIView = {
    let shadowView = UIView()
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOpacity = 0.25
    shadowView.layer.shadowRadius = 2
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
    return shadowView
  }()

  private let markingCircularBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = DesignSystemColor.main03
    view.layer.cornerRadius = Metrics.markingSize * 0.5
    return view
  }()

  private let textStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .leading
    stackView.axis = .vertical
    stackView.spacing = 2
    return stackView
  }()

  private let imageIncludeStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 10
    stackView.alignment = .center
    return stackView
  }()

  private let wholeStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .equalSpacing
    stackView.alignment = .top
    return stackView
  }()

  private let containerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8
    view.backgroundColor = DesignSystemColor.secondaryBackground
    return view
  }()

  // MARK: - Initializations

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
    setupStyles()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayouts()
    setupConstraints()
    setupStyles()
  }

  private func setupLayouts() {
    contentView.addSubview(containerView)
    containerView.addSubview(wholeStackView)

    wholeStackView.addArrangedSubview(imageIncludeStackView)
    wholeStackView.addArrangedSubview(markingCircularContainerView)

    markingCircularContainerView.addSubview(markingCircularBackgroundView)

    imageIncludeStackView.addArrangedSubview(profileImageView)
    imageIncludeStackView.addArrangedSubview(textStackView)

    textStackView.addArrangedSubview(nicknameLabel)
    textStackView.addArrangedSubview(distanceLabel)
  }

  private func setupConstraints() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    wholeStackView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    markingCircularContainerView.translatesAutoresizingMaskIntoConstraints = false
    markingCircularBackgroundView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

        wholeStackView.topAnchor.constraint(
          equalTo: containerView.topAnchor,
          constant: Metrics.wholeStackViewEdge
        ),
        wholeStackView.bottomAnchor.constraint(
          equalTo: containerView.bottomAnchor,
          constant: -Metrics.wholeStackViewEdge
        ),
        wholeStackView.leadingAnchor.constraint(
          equalTo: containerView.leadingAnchor,
          constant: Metrics.wholeStackViewEdge
        ),
        wholeStackView.trailingAnchor.constraint(
          equalTo: containerView.trailingAnchor,
          constant: -Metrics.wholeStackViewEdge
        ),

        profileImageView.widthAnchor.constraint(equalToConstant: Metrics.profileImageSize),
        profileImageView.heightAnchor.constraint(equalToConstant: Metrics.profileImageSize),

        markingCircularContainerView.widthAnchor.constraint(equalToConstant: Metrics.markingSize),
        markingCircularContainerView.heightAnchor.constraint(equalToConstant: Metrics.markingSize),

        markingCircularBackgroundView.topAnchor.constraint(equalTo: markingCircularContainerView.topAnchor),
        markingCircularBackgroundView.bottomAnchor.constraint(equalTo: markingCircularContainerView.bottomAnchor),
        markingCircularBackgroundView.leadingAnchor.constraint(equalTo: markingCircularContainerView.leadingAnchor),
        markingCircularBackgroundView.trailingAnchor.constraint(equalTo: markingCircularContainerView.trailingAnchor),
      ]
    )
  }

  private func setupStyles() {
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.25
    contentView.layer.shadowRadius = 2
    contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    contentView.backgroundColor = .clear
  }

  // MARK: Internal

  func configure(with imageName: String) {
    profileImageView.image = UIImage(systemName: imageName)
  }
}

// MARK: SessionParticipantCell.Metrics

private extension SessionParticipantCell {
  enum Metrics {
    static let profileImageSize: CGFloat = 64
    static let wholeStackViewEdge: CGFloat = 10
    static let markingSize: CGFloat = 12
  }

  enum Strings {
    static let nicknameAccessibilityHint = "닉네임"
    static let workoutDistanceAccessibilityHint = "운동한 거리"
  }
}
