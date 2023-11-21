//
//  NoRecordsView.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/17.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import DesignSystem
import UIKit

// MARK: - NoRecordsView

final class NoRecordsView: UIView {
  private let noRecordLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 기록이 없습니다\n기록하러 가볼까요?"
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .title3)
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }
}

private extension NoRecordsView {
  func configureUI() {
    backgroundColor = DesignSystemColor.gray01

    addSubview(noRecordLabel)
    NSLayoutConstraint.activate([
      noRecordLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.topBottomPadding),
      noRecordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.leadingTrailing),
      noRecordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.leadingTrailing),
      noRecordLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.topBottomPadding),
    ])
  }
}

// MARK: - Metrics

private enum Metrics {
  static let topBottomPadding: CGFloat = 35
  static let leadingTrailing: CGFloat = 60
}
