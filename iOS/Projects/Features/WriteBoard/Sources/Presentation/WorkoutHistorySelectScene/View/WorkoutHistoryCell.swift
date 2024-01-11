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
    var image = UIImage(systemName: "figure.run", withConfiguration: UIImage.configure)

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

    static let middleLabelWidth: CGFloat = 82

    static let imageViewWidthAndHeight: CGFloat = 53
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
      .constraint(equalTo: contentView.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    itemStackView.trailingAnchor
      .constraint(equalTo: contentView.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    itemStackView.bottomAnchor
      .constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.contentViewAndItemSpacing).isActive = true

    workoutTitleLabel.widthAnchor.constraint(equalToConstant: Metrics.middleLabelWidth).isActive = true

    dateLabel.widthAnchor.constraint(equalToConstant: Metrics.middleLabelWidth).isActive = true

    workoutImageView.widthAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true
    workoutImageView.heightAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true
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

extension WorkoutHistoryCell {
  func configure(_ record: Record) {
    workoutImageView.image = record.image
    workoutTitleLabel.text = record.name
    workoutDistanceLabel.text = record.kmDistance
    dateLabel.text = record.dateString
    timeLabel.text = record.timeDescription
  }
}

private extension Record {
  var timeDescription: String {
    return "\(startTime) ~ \(endTime) \(durationTime)"
  }
  var kmDistance: String {
    return String(Double(distance) / 1000) + "km"
  }
  var name: String {
    switch workoutID {
    case 1:
      return "달리기"
    case 2:
      return "수영"
    case 3:
      return "사이클"
    default:
      return "달리기"
    }
  }
  var image: UIImage? {
    switch workoutID {
    case 1:
      return UIImage(systemName: "figure.run", withConfiguration: UIImage.configure)
    case 2:
      return UIImage(systemName: "figure.pool.swim", withConfiguration: UIImage.configure)
    case 3:
      return UIImage(systemName: "figure.outdoor.cycle", withConfiguration: UIImage.configure)
    default:
      return UIImage(systemName: "figure.run", withConfiguration: UIImage.configure)
    }
  }
}

private extension UIImage {
  static let configure: UIImage.SymbolConfiguration = .init(font: .boldSystemFont(ofSize: 35))
}
