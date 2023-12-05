//
//  SignUpProfileViewController.swift
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

// MARK: - SignUpProfileViewController

public final class SignUpProfileViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
    label.text = "프로필을 만들어 볼까요?"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let profileImageButton: GWProfileButton = {
    let button = GWProfileButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    label.text = "닉네임"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let nickNameBoxView: NickNameBoxView = {
    let view = NickNameBoxView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let nickNameCheckerView: NickNameCheckerView = {
    let view = NickNameCheckerView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let completionButton: UIButton = {
    let configuration = UIButton.Configuration.mainEnabled(title: "완료")
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = .preferredFont(forTextStyle: .headline, weight: .bold)
    return button
  }()

  private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindUI()
  }
}

private extension SignUpProfileViewController {
  func configureUI() {
    view.backgroundColor = DesignSystemColor.secondaryBackground
    view.addGestureRecognizer(tapGestureRecognizer)

    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.topInterval),
    ])

    view.addSubview(profileImageButton)
    NSLayoutConstraint.activate([
      profileImageButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.sectionInterval),
      profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      profileImageButton.widthAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
      profileImageButton.heightAnchor.constraint(equalToConstant: Metrics.profileImageButtonSize),
    ])

    view.addSubview(nickNameLabel)
    NSLayoutConstraint.activate([
      nickNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      nickNameLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: Metrics.sectionInterval),
    ])

    view.addSubview(nickNameBoxView)
    NSLayoutConstraint.activate([
      nickNameBoxView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      nickNameBoxView.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: Metrics.componentInterval),
      nickNameBoxView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
    ])

    view.addSubview(nickNameCheckerView)
    NSLayoutConstraint.activate([
      nickNameCheckerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      nickNameCheckerView.topAnchor.constraint(equalTo: nickNameBoxView.bottomAnchor, constant: Metrics.componentInterval),
      nickNameCheckerView.widthAnchor.constraint(equalToConstant: Metrics.nickNameCheckerWidth),
    ])

    view.addSubview(completionButton)
    NSLayoutConstraint.activate([
      completionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      completionButton.topAnchor.constraint(equalTo: nickNameBoxView.bottomAnchor, constant: Metrics.buttonInteval),
      completionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
      completionButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.safeAreaInterval),
    ])
  }
}

private extension SignUpProfileViewController {
  @objc func viewTapped(gestureRecognizer _: UITapGestureRecognizer) {
    nickNameBoxView.textField.resignFirstResponder()
  }
}

private extension SignUpProfileViewController {
  func bindUI() {
    nickNameBoxView.nickNameDidChangedPublisher
      .sink { _ in
        // TODO: ViewModel로 닉네임 넘겨서 사용가능한닉인지 아닌지 받아와서 사용가능하면 true/false
        // TODO: NickNameBoxView 사용가능, 불가능
        // TODO: NickNameCheckerView 사용가능, 불가능
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Metrics

private enum Metrics {
  static let safeAreaInterval: CGFloat = 24
  static let topInterval: CGFloat = 81
  static let sectionInterval: CGFloat = 48
  static let componentInterval: CGFloat = 9
  static let buttonInteval: CGFloat = 258
  static let profileImageButtonSize: CGFloat = 100
  static let nickNameCheckerWidth: CGFloat = 175
}
