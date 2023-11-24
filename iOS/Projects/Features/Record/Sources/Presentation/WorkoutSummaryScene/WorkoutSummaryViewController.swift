//
//  WorkoutSummaryViewController.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/22/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - WorkoutSummaryViewController

final class WorkoutSummaryViewController: UIViewController {
  // MARK: - Subjects

  private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()

  // MARK: Properties

  private let viewModel: WorkoutSummaryViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: UI Components

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "고생하셨어요."
    label.textAlignment = .left
    label.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
    return label
  }()

  private let summaryCardView: WorkoutSummaryCardView = {
    let cardView = WorkoutSummaryCardView()
    cardView.layer.shadowOffset = .init(width: 0, height: 2)
    cardView.layer.shadowRadius = 2
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.25
    return cardView
  }()

  private let writeButton: UIButton = {
    let button = UIButton(configuration: .mainEnabled(title: Constants.writeButton))
    button.configuration?.font = .preferredFont(forTextStyle: .headline)
    return button
  }()

  private let homeButton: UIButton = {
    let button = UIButton(configuration: .mainDisabled(title: Constants.initialScreenButton))
    button.configuration?.font = .preferredFont(forTextStyle: .headline)
    return button
  }()

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 18
    return stackView
  }()

  // MARK: Initializations

  init(viewModel: WorkoutSummaryViewModelRepresentable) {
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
    setupLayouts()
    setupConstraints()
    setupStyles()
    bind()
    viewDidLoadSubject.send(())
  }

  // MARK: Configuration

  private func setupLayouts() {
    view.addSubview(stackView)

    for view in [titleLabel, summaryCardView, writeButton, homeButton] {
      stackView.addArrangedSubview(view)
    }
  }

  private func setupConstraints() {
    let safeArea: UILayoutGuide = view.safeAreaLayoutGuide

    stackView.translatesAutoresizingMaskIntoConstraints = false
    writeButton.translatesAutoresizingMaskIntoConstraints = false
    homeButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.stackViewTop),
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.horizontal),
        stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.horizontal),
        writeButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight),
        homeButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight),
      ]
    )
  }

  private func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  private func bind() {
    let output = viewModel.transform(input: .init(viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher()))

    output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        switch state {
        case .idle:
          break
        case let .fetchSummary(model):
          self?.summaryCardView.configure(with: model)
        case let .alert(error):
          self?.showAlert(with: error)
        }
      }
      .store(in: &subscriptions)
  }

  // MARK: - Custom Methods

  /// 에러 알림 문구를 보여줍니다.
  private func showAlert(with error: Error) {
    let alertController = UIAlertController(title: "알림", message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "확인", style: .default))
    present(alertController, animated: true)
  }
}

private extension WorkoutSummaryViewController {
  enum Metrics {
    static let stackViewTop: CGFloat = 12
    static let horizontal: CGFloat = 24
    static let buttonHeight: CGFloat = 44
  }

  enum Constants {
    static let writeButton: String = "글쓰러 가기"
    static let initialScreenButton: String = "처음으로"
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
#Preview {
  WorkoutSummaryViewController(viewModel: WorkoutSummaryViewModel(workoutSummaryUseCase: WorkoutSummaryUseCase(repository: WorkoutSummaryRepository(session: URLSession.shared), workoutRecordID: 0)))
}
