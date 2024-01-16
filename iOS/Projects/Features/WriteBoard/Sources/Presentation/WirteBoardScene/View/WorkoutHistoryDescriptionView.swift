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

final class WorkoutHistoryDescriptionView: UIStackView {
  init(record: Record) {
    super.init(frame: .zero)
    axis = .vertical
    tableCellStackView = makeTableCellStackView(record)
    setupViewHierarchyAndConstraints()
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
    addArrangedSubview(workoutHistoryTitleLabel)
    guard let tableCellStackView else {
      return
    }
    spacing = Constants.inGroupTitleAndContentSpacing
    addArrangedSubview(tableCellStackView)
  }

  private func makeTableCellStackView(_ record: Record) -> UIStackView {
    let tableCellStackView: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [
        WorkoutHistoryDescriptionRowView(titleString: Constants.workoutName, description: record.name),
        WorkoutHistoryDescriptionRowView(titleString: Constants.date, description: record.dateString),
        WorkoutHistoryDescriptionRowView(titleString: Constants.time, description: record.durationTime + " (" + record.startTime + "~" + record.endTime + ")"),
        WorkoutHistoryDescriptionRowView(titleString: Constants.distance, description: String(format: "%.1f", Double(record.distance) / 1000) + "km"),
      ])
      stackView.axis = .vertical
      stackView.spacing = Constants.cellSpacing

      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
    }()
    return tableCellStackView
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init(coder _: NSCoder) {
    fatalError("사용할 수 없는 생성자 입니다.")
  }

  private enum Constants {
    static let workoutName: String = "운동 종류"
    static let date: String = "날짜"
    static let time = "시간"
    static let distance = "거리"

    static let inGroupTitleAndContentSpacing: CGFloat = 12

    static let cellSpacing: CGFloat = 6
  }
}

// MARK: - WorkoutHistoryDescriptionRowView

private final class WorkoutHistoryDescriptionRowView: UIStackView {
  init(titleString: String, description: String) {
    super.init(frame: .zero)
    titleLabel.text = titleString
    descriptionLabel.text = description

    distribution = .fillProportionally
    setupViewHierarchyAndConstraints()
  }

  override init(frame _: CGRect) {
    super.init(frame: .zero)
  }

  @available(*, unavailable)
  required init(coder _: NSCoder) {
    fatalError("사용할 수 없습니다.")
  }

  private let spacingView: UIView = {
    let view = UIView()

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3)
    label.tintColor = DesignSystemColor.primaryText
    label.textAlignment = .left

    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline, weight: .bold)
    label.tintColor = DesignSystemColor.primaryText

    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  func setupViewHierarchyAndConstraints() {
    addArrangedSubview(spacingView)
    spacingView.widthAnchor.constraint(equalToConstant: Constants.spacingViewWidth).isActive = true

    addArrangedSubview(titleLabel)
    titleLabel.widthAnchor.constraint(equalToConstant: Constants.titleWidth).isActive = true

    addArrangedSubview(descriptionLabel)
    descriptionLabel.widthAnchor.constraint(equalToConstant: Constants.descriptionWidth).isActive = true
  }

  enum Constants {
    static let titleWidth: CGFloat = 99
    static let descriptionWidth: CGFloat = 212

    static let titleAndDescriptionWidthSpacing: CGFloat = 15

    static let intrinsicContentHeight: CGFloat = 24

    static let spacingViewWidth: CGFloat = 9
  }
}
