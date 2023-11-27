//
//  CountDownBeforeWorkoutViewController.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/27/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import Log
import UIKit

// MARK: - CountDownBeforeWorkoutViewController

final class CountDownBeforeWorkoutViewController: UIViewController {
  // MARK: Properties

  private let viewModel: CountDownBeforeWorkoutViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  var timerSubject: PassthroughSubject<String, Never> = .init()

  // MARK: UI Components

  private let countDownLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 120, weight: .bold)
    label.text = "10"
    label.textColor = DesignSystemColor.primaryBackground

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let countDownLabelCover: UIView = {
    let view = UIView()
    view.backgroundColor = DesignSystemColor.main03

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // MARK: Initializations

  init(viewModel: CountDownBeforeWorkoutViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

private extension CountDownBeforeWorkoutViewController {
  // MARK: Configuration

  private func setup() {
    setupHierarchyAndConstraints()
    bind()
    setupStyles()
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(countDownLabelCover)
    countDownLabelCover.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    countDownLabelCover.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    countDownLabelCover.widthAnchor.constraint(equalToConstant: Metrics.coverWidthAndHeight).isActive = true
    countDownLabelCover.heightAnchor.constraint(equalToConstant: Metrics.coverWidthAndHeight).isActive = true

    view.addSubview(countDownLabel)
    countDownLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    countDownLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  /// if let을 활용한 이유는 Subject를 guard로 검사하게 된다면
  /// 시간이 지났을 때 현재 내가 가르키고 있는 subject가 nil이 될수도 있는 위험이 입니다.
  /// 따라서 subject에 send를 보낼 때 마다 검사를 하고 보내기 위함입니다.
  func sendTimerTextEverySeconds(messageStack: [String], subject: PassthroughSubject<String, Never>?) async {
    var messageStack = messageStack
    guard let message = messageStack.popLast() else {
      return
    }
    if let subject {
      subject.send(message)
    }
    while messageStack.isEmpty {
      let message = messageStack.popLast()
      if let subject, let message {
        sleep(1)
        subject.send(message)
      }
    }
  }

  func bind() {
    Task { [weak self] in
      let messageStack: [String] = (1 ... 3).map(\.description).reversed()
      await self?.sendTimerTextEverySeconds(messageStack: messageStack, subject: self?.timerSubject)
    }

    timerSubject
      .receive(on: RunLoop.main)
      .sink { [weak self] text in
        self?.makeLabelAnimation(labelText: text)
      }
      .store(in: &subscriptions)
  }

  func makeLabelAnimation(labelText: String) {
    countDownLabel.text = labelText
    countDownLabel.transform = CGAffineTransform(scaleX: 1, y: 1)

    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) { [weak self] in
      guard let self else { return }
      let scale = Metrics.minFontTransormScale
      countDownLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    } completion: { _ in
    }
  }

  enum Metrics {
    static let coverWidthAndHeight: CGFloat = 240

    static let maxFontSizeOfAnimation: UIFont = .systemFont(ofSize: 120, weight: .bold)
    static let minFontTransormScale: CGFloat = 0.6

    static let timerValue = 3
  }
}
