//
//  LoginViewController.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import AuthenticationServices
import Combine
import OSLog
import UIKit

// MARK: - LoginViewController

final class LoginViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let viewModel: LoginViewModelRepresentable
  private let credentialSubject = PassthroughSubject<AuthorizationInfo, Never>()

  private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
    let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(appleSignInButtonDidTapped), for: .touchUpInside)
    return button
  }()

  init(viewModel: LoginViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  @objc private func appleSignInButtonDidTapped() {
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = []

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
}

// MARK: UI

private extension LoginViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground

    let safeArea = view.safeAreaLayoutGuide
    view.addSubview(appleLoginButton)
    NSLayoutConstraint.activate([
      appleLoginButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.componentInterval),
      appleLoginButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.componentInterval),
      appleLoginButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.componentInterval),
      appleLoginButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight),
    ])
  }
}

private extension LoginViewController {
  func bindViewModel() {
    let input = LoginViewModelInput(appleLoginButtonDidTap: credentialSubject.eraseToAnyPublisher())

    let output = viewModel.transform(input: input)

    output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.render(state: state)
      }
      .store(in: &subscriptions)
  }

  func render(state: LoginState) {
    switch state {
    case .idle:
      break
    }
  }
}

// MARK: - Metrics

private enum Metrics {
  static let componentInterval: CGFloat = 51
  static let buttonHeight: CGFloat = 50
}

// MARK: - LoginViewController + ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
  public func authorizationController(
    controller _: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let identityToken = credential.identityToken,
          let authorizationCode = credential.authorizationCode
    else {
      return
    }
    let authoriztionInfo = AuthorizationInfo(identityToken: identityToken, authorizationCode: authorizationCode)
    credentialSubject.send(authoriztionInfo)
  }
}

// MARK: - LoginViewController + ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(
    for _: ASAuthorizationController
  ) -> ASPresentationAnchor {
    return view.window!
  }
}
