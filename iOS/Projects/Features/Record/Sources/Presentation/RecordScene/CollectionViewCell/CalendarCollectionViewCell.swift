//
//  CalendarCollectionViewCell.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/18.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - CalendarCollectionViewCell

final class CalendarCollectionViewCell: UICollectionViewCell {
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 1
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    return stackView
  }()

  let dayOfWeekLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .footnote)
    label.text = "월"
    label.textColor = DesignSystemColor.gray02
    return label
  }()

  let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body, with: .traitBold)
    label.text = "16"
    label.textColor = DesignSystemColor.gray02
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func prepareForReuse() {
    dayOfWeekLabel.textColor = DesignSystemColor.gray02
    dateLabel.textColor = DesignSystemColor.gray02
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

  func configure(calendarInformation: CalendarInforamtion) {
    configureUI()
    dayOfWeekLabel.text = calendarInformation.dayOfWeek
    dateLabel.text = calendarInformation.date
  }

  func configureTextColor(isSelected: Bool) {
    guard isSelected else {
      dayOfWeekLabel.textColor = DesignSystemColor.gray02
      dateLabel.textColor = DesignSystemColor.gray02
      return
    }
    dayOfWeekLabel.textColor = DesignSystemColor.main03
    dateLabel.textColor = DesignSystemColor.main03
  }
}

private extension CalendarCollectionViewCell {
  func configureUI() {
    contentView.backgroundColor = DesignSystemColor.secondaryBackground

    [dayOfWeekLabel, dateLabel].forEach {
      stackView.addArrangedSubview($0)
    }
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
}

// MARK: - CalendarInforamtion

struct CalendarInforamtion {
  let dayOfWeek: String
  let date: String
}
