//
//  WorkoutHistoryCell.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/10/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - WorkoutHistoryCell

final class WorkoutHistoryCell: UITableViewCell {
  static let identifier = "WorkoutHistoryCell"

  override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    setup()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("cant init")
  }

  private let workoutTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title2)
    label.text = "사이클"
    label.textAlignment = .right
    label.setContentHuggingPriority(.required, for: .horizontal)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let workoutDistanceLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .headline)
    label.text = "1.5 km"

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var header: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [workoutTitleLabel, workoutDistanceLabel])
    stackView.axis = .horizontal
    stackView.spacing = Metrics.headerSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "1월 10일"
    label.textAlignment = .right

    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let timeLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "06:00 ~ 06:30 (30분)"
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var footer: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
    stackView.axis = .horizontal
    stackView.spacing = Metrics.footerSpacing
    stackView.distribution = .fillProportionally

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var descriptionContentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      header, footer,
    ])
    stackView.spacing = Metrics.headerAndFooterSpacing
    stackView.axis = .vertical

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let workoutImageView: UIImageView = {
    let configure: UIImage.SymbolConfiguration = .init(font: .boldSystemFont(ofSize: 35))
    var image = UIImage(systemName: "figure.run", withConfiguration: configure)

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.setContentHuggingPriority(.required, for: .horizontal)
    imageView.tintColor = DesignSystemColor.primaryText

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var itemStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [workoutImageView, descriptionContentStackView])
    stackView.spacing = Metrics.imageAndContentSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private enum Metrics {
    static let headerSpacing: CGFloat = 12
    static let footerSpacing: CGFloat = 12
    static let headerAndFooterSpacing: CGFloat = 9
    static let imageAndContentSpacing: CGFloat = 15

    static let contentViewAndItemSpacing: CGFloat = 12
  }
}

private extension WorkoutHistoryCell {
  func setup() {
    setupStyle()
    setupViewHierarchyAndConstraints()
  }

  func setupStyle() {
    contentView.backgroundColor = DesignSystemColor.secondaryBackground
  }

  func setupViewHierarchyAndConstraints() {
    contentView.addSubview(itemStackView)
    itemStackView.topAnchor
      .constraint(equalTo: contentView.topAnchor, constant: Metrics.contentViewAndItemSpacing).isActive = true
    itemStackView.leadingAnchor
      .constraint(equalTo: contentView.leadingAnchor, constant: 23).isActive = true
    itemStackView.trailingAnchor
      .constraint(equalTo: contentView.trailingAnchor, constant: -23).isActive = true
    itemStackView.bottomAnchor
      .constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.contentViewAndItemSpacing).isActive = true

    workoutTitleLabel.widthAnchor.constraint(equalToConstant: 82).isActive = true
    dateLabel.widthAnchor.constraint(equalToConstant: 82).isActive = true

    workoutImageView.widthAnchor.constraint(equalToConstant: 53).isActive = true
    workoutImageView.heightAnchor.constraint(equalToConstant: 53).isActive = true
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
