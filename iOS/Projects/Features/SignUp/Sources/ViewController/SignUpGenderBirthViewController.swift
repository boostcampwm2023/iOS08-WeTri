//
//  SignUpGenderBirthViewController.swift
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

// MARK: - SignUpGenderBirthViewController

public final class SignUpGenderBirthViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateFormatter = DateFormatter()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
    label.text = "먼저, 성별과 태어난 날을 알려주세요."
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let genderLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    label.text = "성별"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let genderStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 25
    return stackView
  }()

  private let maleButton: UIButton = {
    let button = UIButton()
    button.updateConfiguration(title: "남성")
    return button
  }()

  private let femaleButton: UIButton = {
    let button = UIButton()
    button.updateConfiguration(title: "여성")
    return button
  }()

  private let birthLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    label.text = "생년월일"
    label.textColor = DesignSystemColor.primaryText
    return label
  }()

  private let datePickerBoxView: DatePickerBoxView = {
    let view = DatePickerBoxView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "ko-KR")
    datePicker.isHidden = true
    return datePicker
  }()

  private let nextButton: UIButton = {
    var configuration = UIButton.Configuration.mainDisabled(title: "다음")
    configuration.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
    configuration.titleAlignment = .center
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindUI()
  }
}

private extension SignUpGenderBirthViewController {
  func configureUI() {
    view.backgroundColor = DesignSystemColor.primaryBackground

    [maleButton, femaleButton].forEach {
      genderStackView.addArrangedSubview($0)
    }

    view.addGestureRecognizer(tapGestureRecognizer)

    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.topInterval),
    ])

    view.addSubview(genderLabel)
    NSLayoutConstraint.activate([
      genderLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      genderLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.sectionInterval),
    ])

    view.addSubview(genderStackView)
    NSLayoutConstraint.activate([
      genderStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      genderStackView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: Metrics.componentInterval),
      genderStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
    ])

    view.addSubview(birthLabel)
    NSLayoutConstraint.activate([
      birthLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      birthLabel.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: Metrics.sectionInterval),
      birthLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
    ])

    view.addSubview(datePickerBoxView)
    NSLayoutConstraint.activate([
      datePickerBoxView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      datePickerBoxView.topAnchor.constraint(equalTo: birthLabel.bottomAnchor, constant: Metrics.componentInterval),
      datePickerBoxView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
    ])

    view.addSubview(datePicker)
    NSLayoutConstraint.activate([
      datePicker.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      datePicker.topAnchor.constraint(equalTo: datePickerBoxView.bottomAnchor, constant: Metrics.componentInterval),
      datePicker.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
    ])

    view.addSubview(nextButton)
    NSLayoutConstraint.activate([
      nextButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      nextButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5),
      nextButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
      nextButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.safeAreaInterval),
    ])
  }
}

private extension SignUpGenderBirthViewController {
  @objc func viewTapped(gestureRecognizer _: UITapGestureRecognizer) {
    datePicker.isHidden = true
  }
}

private extension SignUpGenderBirthViewController {
  func bindUI() {
    datePicker.publisher(.valueChanged)
      .sink { [weak self] _ in
        guard let date = self?.datePicker.date,
              let year = self?.formatYear(date: date),
              let month = self?.formatMonth(date: date),
              let day = self?.formatDay(date: date)
        else {
          return
        }
        self?.datePickerBoxView.configureComponent(text: "\(year)년 \(month)월 \(day)일")
      }
      .store(in: &subscriptions)

    datePickerBoxView.datePickerHiddenPublisher
      .sink { [weak self] _ in
        self?.datePicker.isHidden = false
      }
      .store(in: &subscriptions)

    maleButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.maleButton.isSelected = true
        self?.femaleButton.isSelected = false
        self?.buttonUpdate()
      }
      .store(in: &subscriptions)

    femaleButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.maleButton.isSelected = false
        self?.femaleButton.isSelected = true
        self?.buttonUpdate()
      }
      .store(in: &subscriptions)

    nextButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        //
      }
      .store(in: &subscriptions)
  }

  func buttonUpdate() {
    maleButton.updateConfiguration(title: "남성")
    femaleButton.updateConfiguration(title: "여성")
  }
}

// MARK: - Metrics

private enum Metrics {
  static let safeAreaInterval: CGFloat = 24
  static let topInterval: CGFloat = 81
  static let sectionInterval: CGFloat = 48
  static let componentInterval: CGFloat = 9
}

// MARK: - DateFormatter

private extension SignUpGenderBirthViewController {
  func formatYear(date: Date) -> String {
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: date)
  }

  func formatMonth(date: Date) -> String {
    dateFormatter.dateFormat = "MM"
    return dateFormatter.string(from: date)
  }

  func formatDay(date: Date) -> String {
    dateFormatter.dateFormat = "dd"
    return dateFormatter.string(from: date)
  }
}
