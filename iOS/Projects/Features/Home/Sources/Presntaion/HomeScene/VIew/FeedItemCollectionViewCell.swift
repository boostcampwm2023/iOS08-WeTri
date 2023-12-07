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
    imageView.backgroundColor = .blue

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

  private lazy var sportLabelAndNickdateLabelStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      sportLabel,
      dateLabel,
    ])
    stackView.spacing = Metrics.sportLabelAndNickdateLabelSpacing
    stackView.axis = .horizontal

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var nickNameLabelAndSportDateLabelStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      nickNameLabel,
      sportLabelAndNickdateLabelStackView,
    ])
    stackView.axis = .vertical
    stackView.spacing = Metrics.nickNameLabelAndSportDateLabelSpacing
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var feedUserInformationStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      profileImage,
      nickNameLabelAndSportDateLabelStackView,
    ])
    stackView.axis = .horizontal
    stackView.spacing = Metrics.profileImageAndUserInformationLabelStackViewSpacing
    stackView.setContentHuggingPriority(.init(rawValue: 100), for: .horizontal)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let feedEllipsisButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    button.tintColor = DesignSystemColor.gray03
    button.backgroundColor = .blue

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var cardHeaderStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      feedUserInformationStackView,
      feedEllipsisButton,
    ])
    stackView.axis = .horizontal
    stackView.spacing = Metrics.feedUserInformationAndFeedEllipsisButtonSpacing

    // 양쪽 정렬 코드
    stackView.semanticContentAttribute = .forceLeftToRight

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  // MARK: - 본문 내용에 관한 Property입니다.

  private let feedDetailTextLabel: UILabel = {
    let label = UILabel()
    label.text = Constants.feedDetailText
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 2
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let feedDetailImages: UIView = {
    let view = UIView()
    view.backgroundColor = .cyan

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let feedDetailImageView: UIImageView = {
    let imageView = UIImageView()

    imageView.backgroundColor = .blue
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let heartButton: UIButton = {
    let button = UIButton(configuration: .plain())
    var configure = button.configuration
    configure?.image = UIImage(systemName: Constants.heartButtonSystemName)
    configure?.title = "123,456"
    button.configuration = configure

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let dividingLine: UIView = {
    let view = UIView()
    view.backgroundColor = DesignSystemColor.gray03

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}

private extension FeedItemCollectionViewCell {
  func setupViewHierarchyAndConstraints() {
    let safeArea = safeAreaLayoutGuide

    contentView.addSubview(cardHeaderStackView)
    cardHeaderStackView.topAnchor
      .constraint(equalTo: safeArea.topAnchor, constant: Metrics.headerTopAnchorSpacing).isActive = true
    cardHeaderStackView.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    cardHeaderStackView.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true

    contentView.addSubview(feedDetailTextLabel)
    feedDetailTextLabel.topAnchor
      .constraint(equalTo: cardHeaderStackView.bottomAnchor, constant: Metrics.headerAndFeedDetailTextLabelSpacing).isActive = true
    feedDetailTextLabel.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    feedDetailTextLabel.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true

    contentView.addSubview(feedDetailImages)
    feedDetailImages.topAnchor
      .constraint(equalTo: feedDetailTextLabel.bottomAnchor, constant: Metrics.feedDetailTextLabelAndFeedContentImagesSpacing).isActive = true
    feedDetailImages.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor).isActive = true
    feedDetailImages.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor).isActive = true
    feedDetailImages.heightAnchor.constraint(equalToConstant: Metrics.feedContentImagesHeight).isActive = true

    contentView.addSubview(heartButton)
    heartButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    heartButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    heartButton.bottomAnchor
      .constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.bottomAndHeartButtonSpacing).isActive = true

    contentView.addSubview(dividingLine)
    dividingLine.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    dividingLine.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    dividingLine.bottomAnchor
      .constraint(equalTo: heartButton.topAnchor, constant: -Metrics.heartButtonAndDividingLineSpacing).isActive = true
    dividingLine.heightAnchor.constraint(equalToConstant: Metrics.dividingLineHeight).isActive = true

    // 이미지 뷰 너비와 높이 조정
    profileImage.widthAnchor.constraint(equalToConstant: Metrics.profileImageHeight).isActive = true
    profileImage.heightAnchor.constraint(equalToConstant: Metrics.profileImageHeight).isActive = true
  }

  func setup() {
    setStyle()
    setupViewHierarchyAndConstraints()
  }

  func setStyle() {
    backgroundColor = .red
  }

  enum Metrics {
    static let headerTopAnchorSpacing: CGFloat = 6
    static let sportLabelAndNickdateLabelSpacing: CGFloat = 3
    static let nickNameLabelAndSportDateLabelSpacing: CGFloat = 4
    static let profileImageAndUserInformationLabelStackViewSpacing: CGFloat = 12
    static let feedUserInformationAndFeedEllipsisButtonSpacing: CGFloat = 80

    static let headerAndFeedDetailTextLabelSpacing: CGFloat = 12
    static let feedDetailTextLabelAndFeedContentImagesSpacing: CGFloat = 16

    static let bottomAndHeartButtonSpacing: CGFloat = 6
    static let heartButtonAndDividingLineSpacing: CGFloat = 6

    static let dividingLineHeight: CGFloat = 1

    static let feedContentImagesHeight: CGFloat = 246

    static let profileImageHeight: CGFloat = 56
  }

  enum Constants {
    static let heartButtonSystemName = "heart"

    static let feedDetailText = "정당은 그 목적·조직과 활동이 민주적이어야 하며, 국민의 정치적 의사형성에 참여하는데 필요한 조직을 가져야 한다. 대통령은 내우·외환·천재·지변 또는 중대한 재정·경제상의 위기에 있어서 없을 때에 한하여 최소한으로 필"
  }
}
