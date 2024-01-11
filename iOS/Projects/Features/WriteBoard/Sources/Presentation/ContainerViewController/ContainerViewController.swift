//
//  ContainerViewController.swift
//  WriteBoardFeature
//
//  Created by MaraMincho on 1/9/24.
//  Copyright © 2024 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - ContainerViewController

final class ContainerViewController: UINavigationController {
  // MARK: Properties

  private let viewModel: ContainerViewModelRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  private var cancelWriteBoardPublisher: PassthroughSubject<Void, Never> = .init()
  private var confirmAlertPublisher: PassthroughSubject<Void, Never> = .init()

  // MARK: Initializations

  init(viewModel: ContainerViewModelRepresentable) {
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

  private enum AlertHelper {
    static var title: String { "정말 종료하시겠습니까?" }
    static var description: String { "지금까지 작성했던 모든 것들이 사라집니다." }

    static var cancelDescription: String { "취소" }

    static var confimDescription: String { "확인" }
  }
}

private extension ContainerViewController {
  func setup() {
    setupStyles()
    bind()
    presentationController?.delegate = self
  }

  func setupStyles() {
    view.backgroundColor = DesignSystemColor.primaryBackground
  }

  func bind() {
    let output = viewModel.transform(
      input: .init(
        showAlertPublisher: cancelWriteBoardPublisher.eraseToAnyPublisher(),
        dismissWriteBoardPublisher: confirmAlertPublisher.eraseToAnyPublisher()
      )
    )
    output.sink { [weak self] state in
      switch state {
      case .showAlert:
        self?.showFinishAlert()

      case .idle:
        break
      }
    }
    .store(in: &subscriptions)
  }
}

// MARK: UIAdaptivePresentationControllerDelegate

extension ContainerViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerShouldDismiss(_: UIPresentationController) -> Bool {
    showFinishAlert()
    return false
  }

  private func showFinishAlert() {
    let alertController = UIAlertController(
      title: AlertHelper.title,
      message: AlertHelper.description,
      preferredStyle: .alert
    )

    let cancelHandler: (UIAlertAction) -> Void = { _ in return }

    let confirmHandler: (UIAlertAction) -> Void = { [weak self] _ in
      self?.confirmAlertPublisher.send()
    }

    let cancelAction = UIAlertAction(title: AlertHelper.cancelDescription, style: .default, handler: cancelHandler)
    let confirmAction = UIAlertAction(title: AlertHelper.confimDescription, style: .default, handler: confirmHandler)

    alertController.addAction(cancelAction)
    alertController.addAction(confirmAction)
    present(alertController, animated: true)
  }
}
