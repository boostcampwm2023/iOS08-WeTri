//
//  LoginViewController.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import AuthenticationServices
import AVFoundation
import Combine
import CombineCocoa
import DesignSystem
import Log
import UIKit

// MARK: - LoginViewController

final class LoginViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let viewModel: LoginViewModelRepresentable
  private let credentialSubject = PassthroughSubject<AuthorizationInfo, Never>()
  private let loginSubject = PassthroughSubject<Void, Never>()

  private var timeObserverToken: Any?
  private let playerLayer: AVPlayerLayer? = {
    guard
      let bundle = Bundle(for: LoginViewController.self).path(forResource: "running", ofType: "mp4")
    else {
      return nil
    }
    let videoURL = URL(fileURLWithPath: bundle)
    let playerItem = AVPlayerItem(url: videoURL)
    let player = AVPlayer(playerItem: playerItem)
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resizeAspectFill // 영상을 화면에 꽉 차게 표시
    return playerLayer
  }()

  private lazy var logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = .logoImageDark
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
    let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let policyTextView: UITextView = {
    let attributedString = NSMutableAttributedString(string: "가입을 진행할 경우, 서비스 약관 및\n개인정보 처리방침에 동의한것으로 간주합니다.")
    attributedString.addAttribute(.link, value: PrivacyLink.link, range: NSRange(location: 12, length: 18))

    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.attributedText = attributedString
    textView.isEditable = false
    textView.isScrollEnabled = false
    textView.attributedText = attributedString
    textView.dataDetectorTypes = .link
    textView.font = .systemFont(ofSize: 12, weight: .medium)
    textView.textColor = DesignSystemColor.primaryText
    textView.textAlignment = .center
    return textView
  }()

  init(viewModel: LoginViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    Log.make().debug("\(Self.self) deinitialized")
    if let timeObserverToken {
      playerLayer?.player?.removeTimeObserver(timeObserverToken)
      self.timeObserverToken = nil
    }
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindViewModel()
    bindUI()
  }

  private func setupVideoPlayerDuration() {
    // 재생 종료 시점 감지
    guard let duration = playerLayer?.player?.currentItem?.asset.duration
    else {
      return
    }
    let endTime = CMTimeSubtract(duration, CMTimeMake(value: 5, timescale: 1)) // 종료 5초 전
    timeObserverToken = playerLayer?.player?.addBoundaryTimeObserver(forTimes: [NSValue(time: endTime)], queue: .main) {
      [weak self] in
      self?.slowDownPlayback()
    }
  }

  private func slowDownPlayback() {
    // 재생 속도를 점차 감소
    guard var rate = playerLayer?.player?.rate else { return }
    let decelerationFactor: Float = 0.98 // 감속 계수: 각 단계마다 속도를 98%로 줄임
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
      if rate > 0.1 {
        rate *= decelerationFactor
        self?.playerLayer?.player?.rate = rate
      } else {
        timer.invalidate()
        self?.playerLayer?.player?.pause()
      }
    }
  }
}

// MARK: UI

private extension LoginViewController {
  func configureUI() {
    view.backgroundColor = DesignSystemColor.secondaryBackground

    let safeArea = view.safeAreaLayoutGuide

    // 비디오가 있으면 설정
    if let playerLayer {
      view.layer.addSublayer(playerLayer)
      playerLayer.frame = view.bounds
      playerLayer.player?.play()
      // 가우시안 블러 효과 추가
      addBlurEffect()

      // 그라디언트 배경 추가
      addGradientLayer()

      // duration 설정
      setupVideoPlayerDuration()
    }

    view.addSubview(logoImageView)
    NSLayoutConstraint.activate([
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: Metrics.imageViewSize),
      logoImageView.heightAnchor.constraint(equalToConstant: Metrics.imageViewSize),
    ])

    view.addSubview(appleLoginButton)
    NSLayoutConstraint.activate([
      appleLoginButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.componentInterval),
      appleLoginButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Metrics.logoButtonInterval),
      appleLoginButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.componentInterval),
      appleLoginButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight),
    ])

    view.addSubview(policyTextView)
    NSLayoutConstraint.activate([
      policyTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.buttonPolicyInterval),
      policyTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
}

// MARK: - Metrics

private enum Metrics {
  static let componentInterval: CGFloat = 51
  static let buttonHeight: CGFloat = 42
  static let imageViewSize: CGFloat = 200
  static let logoButtonInterval: CGFloat = 200
  static let buttonPolicyInterval: CGFloat = 30
}

private extension LoginViewController {
  func bindViewModel() {
    let input = LoginViewModelInput(
      credential: credentialSubject.eraseToAnyPublisher(),
      appleLoginButtonDidTap: loginSubject.eraseToAnyPublisher()
    )

    let output = viewModel.transform(input: input)

    output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.render(state: state)
      }
      .store(in: &subscriptions)
  }

  func bindUI() {
    appleLoginButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.loginSubject.send()
      }
      .store(in: &subscriptions)
  }

  func render(state: LoginState) {
    switch state {
    case .idle:
      break
    case .success:
      appleLogin()
    case let .customError(error):
      Log.make().error("\(error)")
    }
  }

  func appleLogin() {
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = []

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  func addBlurEffect() {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
    blurredEffectView.frame = view.bounds
    view.addSubview(blurredEffectView)
  }

  func addGradientLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    view.layer.addSublayer(gradientLayer)
  }
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

// MARK: - PrivacyLink

private enum PrivacyLink {
  static let link = "https://www.notion.so/geul-woll/207b7ec2bf544a199541d9d916efa17f?pvs=4"
}
