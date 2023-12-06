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
import Photos
import UIKit

// MARK: - SignUpProfileViewController

public final class SignUpProfileViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []
  private let viewModel: SignUpProfileViewModelRepresentable

  private let textFieldEdittingSubject = PassthroughSubject<String, Never>()
  private let imageButtonTapSubject = PassthroughSubject<Void, Never>()

  public init(viewModel: SignUpProfileViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("NO Xib")
  }

  private lazy var imagePicker: UIImagePickerController = {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    return imagePicker
  }()

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
    bindViewModel()
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

  func nickNameEnabled() {
    nickNameBoxView.configureEnabled()
    nickNameCheckerView.configureEnabled()
  }

  func nickNameDisabled() {
    nickNameBoxView.configureDisabled()
    nickNameCheckerView.configureDisabled()
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
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] text in
        Log.make().debug("\(text)")
        self?.textFieldEdittingSubject.send(text)
      }
      .store(in: &subscriptions)

    profileImageButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.imageButtonTapSubject.send()
      }
      .store(in: &subscriptions)
  }

  func bindViewModel() {
    let input = SignUpProfileViewModelInput(
      nickNameTextFieldEditting: textFieldEdittingSubject.eraseToAnyPublisher(),
      imageButtonTap: imageButtonTapSubject.eraseToAnyPublisher()
    )
    let output = viewModel.transform(input: input)
    output
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.render(state: state)
      }
      .store(in: &subscriptions)
  }

  func render(state: SignUpProfileState) {
    switch state {
    case .idle:
      break
    case let .checking(isChecked):
      if isChecked {
        nickNameEnabled()
      } else {
        nickNameDisabled()
      }
    case let .customError(error):
      Log.make().error("\(error)")
    case .image:
      albumAuth()
    }
  }
}

// MARK: PHPhotoLibrary

private extension SignUpProfileViewController {
  /// 앨범 접근 권한 판별하는 함수
  func albumAuth() {
    switch PHPhotoLibrary.authorizationStatus() {
    case .denied:
      showAlertAuth("앨범")
    case .authorized:
      openPhotoLibrary()
    case .notDetermined,
         .restricted:
      PHPhotoLibrary.requestAuthorization { [weak self] state in
        if state == .authorized {
          self?.openPhotoLibrary()
        } else {
          self?.dismiss(animated: true)
        }
      }
    default:
      break
    }
  }

  /// 권한을 거부했을 때 띄워주는 Alert 함수
  func showAlertAuth(
    _ type: String
  ) {
    if let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
      let alertVC = UIAlertController(
        title: "설정",
        message: "\(appName)이(가) \(type) 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
        preferredStyle: .alert
      )
      let cancelAction = UIAlertAction(
        title: "취소",
        style: .cancel,
        handler: nil
      )
      let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
      }
      alertVC.addAction(cancelAction)
      alertVC.addAction(confirmAction)
      present(alertVC, animated: true, completion: nil)
    }
  }

  /// 아이폰에서 앨범에 접근하는 함수
  func openPhotoLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      DispatchQueue.main.async { [weak self] in
        guard let self else {
          return
        }
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .currentContext
        present(imagePicker, animated: true, completion: nil)
      }
    }
  }
}

// MARK: UIImagePickerControllerDelegate

extension SignUpProfileViewController: UIImagePickerControllerDelegate {
  public func imagePickerController(
    _: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    if let image = info[.originalImage] as? UIImage {
      profileImageButton.image = image
    }
    dismiss(animated: true)
  }
}

// MARK: UINavigationControllerDelegate

extension SignUpProfileViewController: UINavigationControllerDelegate {}

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
