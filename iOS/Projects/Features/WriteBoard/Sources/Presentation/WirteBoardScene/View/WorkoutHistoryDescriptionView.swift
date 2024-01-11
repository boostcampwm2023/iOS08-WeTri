//
//  WorkoutHistoryDescriptionView.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/11/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - WorkoutHistoryDescriptionView

final class WorkoutHistoryDescriptionView: UIView {
  init(record: Record) {
    super.init(frame: .zero)

    tableCellStackView = makeTableCellStackView(record)
    setupViewHierarchyAndConstraints()
  }

  private func makeTableCellStackView(_ record: Record) -> UIStackView {
    let tableCellStackView: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [
        WorkoutHistoryTableCellView(titleString: Constants.workoutName, description: record.name),
        WorkoutHistoryTableCellView(titleString: Constants.date, description: record.dateString),
        WorkoutHistoryTableCellView(titleString: Constants.time, description: record.durationTime + " (" + record.startTime + "~" + record.endTime + ")"),
        WorkoutHistoryTableCellView(titleString: Constants.distance, description: String(format: "%01f", Double(record.distance) / 1000) + "km"),
      ])
      stackView.axis = .vertical
      stackView.spacing = Constants.cellSpacing

      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
    }()
    return tableCellStackView
  }
  
  /// UIComponents
  private var tableCellStackView: UIStackView?

  private let workoutHistoryTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "운동 정보"
    label.textColor = DesignSystemColor.primaryText
    label.font = .preferredFont(forTextStyle: .title2, weight: .bold)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  func setupViewHierarchyAndConstraints() {
    addSubview(workoutHistoryTitleLabel)
    workoutHistoryTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleLabelTopSpacing).isActive = true
    workoutHistoryTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true

    guard let tableCellStackView else {
      return
    }

    addSubview(tableCellStackView)
    tableCellStackView.topAnchor
      .constraint(equalTo: workoutHistoryTitleLabel.bottomAnchor, constant: Constants.titleAndTableTopSpacing).isActive = true
    tableCellStackView.leadingAnchor
      .constraint(equalTo: workoutHistoryTitleLabel.leadingAnchor, constant: Constants.titleAndTableLeadingSpacing).isActive = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("사용할 수 없는 생성자 입니다.")
  }

  private enum Constants {
    static let workoutName: String = "운동 종류"
    static let date: String = "날짜"
    static let time = "시간"
    static let distance = "거리"

    static let cellSpacing: CGFloat = 6

    static let titleLabelTopSpacing: CGFloat = 6

    static let titleAndTableTopSpacing: CGFloat = 9
    static let titleAndTableLeadingSpacing: CGFloat = 9
  }
}

// MARK: - WorkoutHistoryTableCellView

private final class WorkoutHistoryTableCellView: UIView {
  init(titleString: String, description: String) {
    super.init(frame: .zero)
    titleLabel.text = titleString
    descriptionLabel.text = description
    setupViewHierarchyAndConstraints()
  }

  override var intrinsicContentSize: CGSize {
    return .init(
      width: titleLabel.frame.width + Constants.titleAndDescriptionWidthSpacing + descriptionLabel.frame.width,
      height: Constants.intrinsicContentHeight
    )
  }

  override init(frame _: CGRect) {
    super.init(frame: .zero)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("사용 할 수 없는 생성자 입니다.")
  }

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3)
    label.tintColor = DesignSystemColor.primaryText
    label.textAlignment = .left

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline, weight: .bold)
    label.tintColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  func setupViewHierarchyAndConstraints() {
    addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel.widthAnchor.constraint(equalToConstant: Constants.titleWidth).isActive = true

    addSubview(descriptionLabel)
    descriptionLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    descriptionLabel.leadingAnchor
      .constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.titleAndDescriptionWidthSpacing).isActive = true
  }

  enum Constants {
    static let titleWidth: CGFloat = 99

    static let titleAndDescriptionWidthSpacing: CGFloat = 15

    static let intrinsicContentHeight: CGFloat = 24
  }
}
