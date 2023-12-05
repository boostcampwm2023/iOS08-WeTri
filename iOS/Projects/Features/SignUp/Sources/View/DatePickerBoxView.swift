//
//  DatePickerBoxView.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import DesignSystem
import Log
import UIKit

// MARK: - DatePickerBoxView

final class DatePickerBoxView: UIView {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateFormatter = DateFormatter()

  private let datePickerHiddenSubject = PassthroughSubject<Void, Never>()

  var datePickerHiddenPublisher: AnyPublisher<Void, Never> {
    return datePickerHiddenSubject.eraseToAnyPublisher()
  }

  private let birthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    label.text = "1998년 06월 15일"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let calendarButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "calendar"), for: .normal)
    button.tintColor = DesignSystemColor.main03
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    bindUI()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("NO Xib")
  }
}

extension DatePickerBoxView {
  func configureComponent(text: String) {
    birthLabel.text = text
  }
}

private extension DatePickerBoxView {
  func configureUI() {
    backgroundColor = DesignSystemColor.primaryBackground
    layer.borderColor = DesignSystemColor.main03.cgColor
    layer.borderWidth = 1.5
    layer.cornerRadius = 10.0

    addSubview(birthLabel)
    NSLayoutConstraint.activate([
      birthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.parentViewInterval),
      birthLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.topBottomInteval),
      birthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.topBottomInteval),
    ])

    addSubview(calendarButton)
    NSLayoutConstraint.activate([
      calendarButton.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.topBottomInteval),
      calendarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.parentViewInterval),
      calendarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.topBottomInteval),
      calendarButton.widthAnchor.constraint(equalToConstant: Metrics.buttonWidth),
    ])
  }

  func bindUI() {
    calendarButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.datePickerHiddenSubject.send()
        Log.make().debug("DatePickerBoxView에서 눌림")
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Metrics

private enum Metrics {
  static let parentViewInterval: CGFloat = 16
  static let topBottomInteval: CGFloat = 13
  static let buttonWidth: CGFloat = 32
}
