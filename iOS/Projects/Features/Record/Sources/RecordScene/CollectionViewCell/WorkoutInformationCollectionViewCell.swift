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
    return label
  }()

  private let timeLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "시간: 07:00~08:00"
    return label
  }()

  private let distanceLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.text = "거리: 12.43km"
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("xib파일을 사용하지않습니다.")
  }

  func configure(workoutInformation: WorkoutInformation) {
    configureUI()
    sportLabel.text = "\(workoutInformation.sport)"
    timeLabel.text = "\(workoutInformation.time)"
    distanceLabel.text = "\(workoutInformation.distance)"
  }
}

private extension WorkoutInformationCollectionViewCell {
  func configureUI() {
    contentView.backgroundColor = DesignSystemColor.gray01

    [sportLabel, timeLabel, distanceLabel].forEach {
      stackView.addArrangedSubview($0)
    }
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.leadingTrailingpadding),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.leadingTrailingpadding),
    ])
  }
}

// MARK: - WorkoutInformation

struct WorkoutInformation {
  let sport: String
  let time: String
  let distance: String
}

// MARK: - Metrics

private enum Metrics {
  static let leadingTrailingpadding: CGFloat = 10
  static let topBottomPadding: CGFloat = 47
}
