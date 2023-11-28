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

  var didFinishTimerTextSubscriptionSubject: PassthroughSubject<Void, Never> = .init()
  var viewDidAppearSubject: PassthroughSubject<Void, Never> = .init()

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

    view.layer.cornerRadius = Metrics.coverWidthAndHeight / 2
    view.clipsToBounds = true

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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewDidAppearSubject.send(())
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
    view.addSubview(countDownLabelCover)
    countDownLabelCover.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    countDownLabelCover.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    countDownLabelCover.widthAnchor.constraint(equalToConstant: Metrics.coverWidthAndHeight).isActive = true
    countDownLabelCover.heightAnchor.constraint(equalToConstant: Metrics.coverWidthAndHeight).isActive = true

    view.addSubview(countDownLabel)
    countDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    countDownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bindViewModel() {
    let input = CountDownBeforeWorkoutViewModelInput(
      viewDidApperPubilsehr: viewDidAppearSubject.eraseToAnyPublisher(),
      didFinsihTimerSubscrion: didFinishTimerTextSubscriptionSubject.eraseToAnyPublisher()
    )

    viewModel
      .transform(input: input)
      .sink(receiveCompletion: { [weak self] stateResults in
        switch stateResults {
        case .failure(_),
             .finished:
          self?.didFinishTimerTextSubscriptionSubject.send(())
        }
      }, receiveValue: { [weak self] state in
        switch state {
        case let .updateMessage(message): self?.makeLabelAnimation(labelText: message)
        case .idle: break
        }
      })
      .store(in: &subscriptions)
  }

  func bind() {
    subscriptions.removeAll()

    bindViewModel()
  }

  func makeLabelAnimation(labelText: String) {
    Log.make().debug("viewController makeLabelAnimation: \(labelText)")
    countDownLabel.text = labelText
    countDownLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
    view.layoutIfNeeded()

    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) { [weak self] in
      guard let self else { return }
      let scale = Metrics.minFontTransormScale
      countDownLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
  }

  enum Metrics {
    static let coverWidthAndHeight: CGFloat = 240

    static let maxFontSizeOfAnimation: UIFont = .systemFont(ofSize: 120, weight: .bold)
    static let minFontTransormScale: CGFloat = 0.6
  }
}
