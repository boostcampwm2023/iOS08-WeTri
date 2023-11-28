//
//  LoginViewController.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import AuthenticationServices
import OSLog
import UIKit

// MARK: - LoginViewController

public final class LoginViewController: UIViewController {
  private let viewModel: LoginViewModelRepresentable

  private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
    let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(appleSignInButtonDidTapped), for: .touchUpInside)
    return button
  }()

  public init(viewModel: LoginViewModelRepresentable) {
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
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      return
    }
    Logger().debug("\(credential)")
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
