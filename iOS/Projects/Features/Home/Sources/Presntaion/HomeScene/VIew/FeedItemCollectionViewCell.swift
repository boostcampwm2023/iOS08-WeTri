//
//  FeedItemCollectionViewCell.swift
//  HomeFeature
//
//  Created by MaraMincho on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
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

  // MARK: - Property

  // MARK: - 프로필 이미지와 정보들을 알 수 있는 Property들의 모음입니다.

  private let profileImage: UIImageView = {
    let imageView = UIImageView()

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "위트라이"
    label.font = .preferredFont(forTextStyle: .title1)
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let sportLabel: UILabel = {
    let label = UILabel()
    label.text = "달리기"
    label.font = .preferredFont(forTextStyle: .title3)
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.text = "2023.12.07"
    label.font = .preferredFont(forTextStyle: .title3)
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var sportLabelAndNickdateLabelStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      sportLabel,
      dateLabel,
    ])
    stackView.spacing = Metrics.sportLabelAndNickdateLabelSpacing
    stackView.axis = .horizontal

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var nickNameLabelAndSportDateLabelStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      nickNameLabel,
      sportLabelAndNickdateLabelStackView,
    ])
    stackView.axis = .vertical
    stackView.spacing = Metrics.nickNameLabelAndSportDateLabelSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var cardHeaderStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      profileImage,
      nickNameLabelAndSportDateLabelStackView,
    ])
    stackView.axis = .horizontal
    stackView.spacing = Metrics.profileImageAndUserInformationLabelStackViewSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  // MARK: - 본문 내용에 관한 Property입니다.
}

private extension FeedItemCollectionViewCell {
  func setup() {
    setStyle()
  }

  func setStyle() {
    backgroundColor = .red
  }

  enum Metrics {
    static let sportLabelAndNickdateLabelSpacing: CGFloat = 3
    static let nickNameLabelAndSportDateLabelSpacing: CGFloat = 4
    static let profileImageAndUserInformationLabelStackViewSpacing: CGFloat = 12
  }
}
