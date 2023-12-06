//
//  NickNameBoxView.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import DesignSystem
import UIKit

// MARK: - NickNameBoxView

final class NickNameBoxView: UIView {
  private var subscriptions: Set<AnyCancellable> = []

  private let nickNameDidChangedSubject = PassthroughSubject<String, Never>()

  var nickNameDidChangedPublisher: AnyPublisher<String, Never> {
    return nickNameDidChangedSubject.eraseToAnyPublisher()
  }

  let textField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = .systemFont(ofSize: 16, weight: .semibold)
    textField.textColor = DesignSystemColor.primaryText
    textField.placeholder = "닉네임을 입력해주세요!"
    return textField
  }()

  private let cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = DesignSystemColor.main03
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    bindUI()
    configureDisabled()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("NO Xib")
  }
}

private extension NickNameBoxView {
  func configureUI() {
    backgroundColor = DesignSystemColor.primaryBackground
    layer.borderColor = DesignSystemColor.main03.cgColor
    layer.borderWidth = 1.5
    layer.cornerRadius = 10.0

    addSubview(textField)
    NSLayoutConstraint.activate([
      textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.parentViewInterval),
      textField.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.topBottomInteval),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.topBottomInteval),
    ])

    addSubview(cancelButton)
    NSLayoutConstraint.activate([
      cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.topBottomInteval),
      cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.parentViewInterval),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.topBottomInteval),
      cancelButton.widthAnchor.constraint(equalToConstant: Metrics.buttonWidth),
    ])
  }

  func bindUI() {
    cancelButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.textField.text = ""
      }
      .store(in: &subscriptions)

    textField.publisher(.editingChanged)
      .sink { [weak self] _ in
        guard let text = self?.textField.text else {
          return
        }
        self?.nickNameDidChangedSubject.send(text)
      }
      .store(in: &subscriptions)
  }
}

extension NickNameBoxView {
  func configureEnabled() {
    textField.textColor = DesignSystemColor.primaryText
    layer.borderColor = DesignSystemColor.main03.cgColor
    cancelButton.tintColor = DesignSystemColor.main03
  }

  func configureDisabled() {
    layer.borderColor = DesignSystemColor.error.cgColor
    textField.textColor = DesignSystemColor.error
    cancelButton.tintColor = DesignSystemColor.error
  }
}

// MARK: - Metrics

private enum Metrics {
  static let parentViewInterval: CGFloat = 16
  static let topBottomInteval: CGFloat = 13
  static let buttonWidth: CGFloat = 32
}
