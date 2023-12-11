//
//  WorkoutInformationCollectionViewCell.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/16.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - WorkoutInformationCollectionViewCell

final class WorkoutInformationCollectionViewCell: UICollectionViewCell {
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 6
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    return stackView
  }()

  private let sportLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "운동: 사이클"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let startTimeLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "시작: 07:00:00"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let endTimeLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "끝: 08:00:00"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let distanceLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "거리: 12.43km"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

  func configure(workoutInformation: WorkoutInformation) {
    configureUI()
    sportLabel.text = "\(workoutInformation.sport)"
    startTimeLabel.text = "\(workoutInformation.startTime) 부터"
    endTimeLabel.text = "\(workoutInformation.endTime) 까지"
    distanceLabel.text = "\(workoutInformation.distance)"
  }
}

private extension WorkoutInformationCollectionViewCell {
  func configureUI() {
    contentView.backgroundColor = DesignSystemColor.gray01
    contentView.layer.cornerRadius = 8

    [sportLabel, startTimeLabel, endTimeLabel, distanceLabel].forEach {
      stackView.addArrangedSubview($0)
    }
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.topBottomPadding),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metrics.topBottomPadding),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.leadingTrailingpadding),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.leadingTrailingpadding),
    ])
  }
}

// MARK: - Metrics

private enum Metrics {
  static let leadingTrailingpadding: CGFloat = 10
  static let topBottomPadding: CGFloat = 47
}

// MARK: - WorkoutInformation

struct WorkoutInformation {
  let sport: String
  let startTime: String
  let endTime: String
  let distance: String
}
