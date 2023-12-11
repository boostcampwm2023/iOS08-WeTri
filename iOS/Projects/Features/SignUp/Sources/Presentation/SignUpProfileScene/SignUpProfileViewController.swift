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
import ImageDownsampling
import Log
import Photos
import UIKit

// MARK: - SignUpProfileViewController

public final class SignUpProfileViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []
  private let viewModel: SignUpProfileViewModelRepresentable

  private let textFieldEdittingSubject = PassthroughSubject<String, Never>()
  private let imageButtonTapSubject = PassthroughSubject<Void, Never>()
  private let imageSetSubject = PassthroughSubject<Data, Never>()
  private let completeButtonTapSubject = PassthroughSubject<Void, Never>()

  let genderBirthSubject = PassthroughSubject<GenderBirth, Never>()

  public init(viewModel: SignUpProfileViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bindViewModel()
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

  private let imageCheckerView: ImageCheckerView = {
    let view = ImageCheckerView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
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

  private let nickNameCheckerView: CheckerView = {
    let view = NickNameCheckerView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let completionButton: UIButton = {
    var configuration = UIButton.Configuration.main(label: "완료")
    let button = UIButton()
    button.configurationUpdateHandler = configuration
    button.configuration?.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isEnabled = false
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

    view.addSubview(imageCheckerView)
    NSLayoutConstraint.activate([
      imageCheckerView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: Metrics.componentInterval),
      imageCheckerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      imageCheckerView.widthAnchor.constraint(equalToConstant: Metrics.checkerWidth),
    ])

    view.addSubview(nickNameLabel)
    NSLayoutConstraint.activate([
      nickNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      nickNameLabel.topAnchor.constraint(equalTo: imageCheckerView.bottomAnchor, constant: Metrics.sectionInterval),
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
      nickNameCheckerView.widthAnchor.constraint(equalToConstant: Metrics.checkerWidth),
    ])

    view.addSubview(completionButton)
    NSLayoutConstraint.activate([
      completionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
      completionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.safeAreaInterval),
      completionButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.safeAreaInterval),
      completionButton.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight),
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

    completionButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.completeButtonTapSubject.send()
      }
      .store(in: &subscriptions)
  }

  func bindViewModel() {
    let input = SignUpProfileViewModelInput(
      nickNameTextFieldEditting: textFieldEdittingSubject.eraseToAnyPublisher(),
      imageButtonTap: imageButtonTapSubject.eraseToAnyPublisher(),
      imageSetting: imageSetSubject.eraseToAnyPublisher(),
      completeButtonTap: completeButtonTapSubject.eraseToAnyPublisher(),
      genderBirth: genderBirthSubject.setFailureType(to: Error.self).eraseToAnyPublisher()
    )
    let output = viewModel.transform(input: input)
    output
      .receive(on: DispatchQueue.main)
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
    case .imageButtonTap:
      showAlertSelect()
    case .success:
      completionButton.isEnabled = true
    case .failure:
      completionButton.isEnabled = false
    case let .customError(error):
      Log.make().error("\(error)")
      if let profileImageError = error as? ImageFormRepositoryError {
        switch profileImageError {
        case .notAccessObjectStorage:
          showAlert(message: "앱의 상태가 불안정합니다.")
        case .notAccessGreenEye:
          showAlert(message: "건전한 사진을 부탁드립니다.")
        case .invalidFileType:
          showAlert(message: "사진 파일이 올바르지 않은 확장자입니다.")
        case .fileSizeTooLarge:
          showAlert(message: "파일의 크기가 너무 큽니다.")
        default:
          showAlert(message: "다시 시도 해주세요.")
        }
      }
    case .image:
      imageCheckerView.configureEnabled()
    }
  }

  private func showAlert(message: String) {
    let alertVC = UIAlertController(
      title: "잘못된 접근입니다.",
      message: message,
      preferredStyle: .alert
    )
    let confirmAction = UIAlertAction(title: "확인", style: .default)
    alertVC.addAction(confirmAction)
    present(alertVC, animated: true, completion: nil)
  }
}

// MARK: PHPhotoLibrary

private extension SignUpProfileViewController {
  /// 버튼을 눌렀을 때, 카메라로 찍을지 앨범에서 고를지 선택하기 위한 얼럿
  func showAlertSelect() {
    let actionSheet = UIAlertController(
      title: "프로필 이미지 설정",
      message: "선택해주세요.",
      preferredStyle: .actionSheet
    )
    let cameraAction = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
      self?.cameraAuth()
    }
    let albumAction = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
      self?.albumAuth()
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(albumAction)
    actionSheet.addAction(cancelAction)
    present(actionSheet, animated: true, completion: nil)
  }

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

  /// 카메라 접근 권한 팔별하는 함수
  func cameraAuth() {
    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
      if granted {
        self?.openCamera()
      } else {
        self?.showAlertAuth("카메라")
      }
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

  /// 아이폰에서 카메라에 접근하는 함수
  func openCamera() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      DispatchQueue.main.async { [weak self] in
        guard let self else {
          return
        }
        imagePicker.sourceType = .camera
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
    do {
      // 앨범에서 사진 선택할 때
      if let url = info[.imageURL] as? URL {
        let imageData = try Data(contentsOf: url)
        let image = try imageData.downsampling(size: profileImageButton.profileSize, scale: .x3)
        profileImageButton.image = image
        guard let downsampledData = image.pngData() else {
          return
        }
        imageSetSubject.send(downsampledData)
      } else {
        // 카메라에서 사진 선택할 때
        guard let image = info[.originalImage] as? UIImage else {
          return
        }
        profileImageButton.image = try image.downsampling(size: profileImageButton.profileSize, scale: .x3)
        guard let downsampledData = image.pngData() else {
          return
        }
        imageSetSubject.send(downsampledData)
        dismiss(animated: true)
      }
    } catch {
      Log.make().error("\(error)")
      profileImageButton.image = UIImage(systemName: "person.fill")
    }
  }
}

// MARK: UINavigationControllerDelegate

extension SignUpProfileViewController: UINavigationControllerDelegate {}

// MARK: - Metrics

private enum Metrics {
  static let safeAreaInterval: CGFloat = 24
  static let topInterval: CGFloat = 30
  static let sectionInterval: CGFloat = 54
  static let componentInterval: CGFloat = 9
  static let buttonInterval: CGFloat = 132
  static let profileImageButtonSize: CGFloat = 100
  static let checkerWidth: CGFloat = 175
  static let checkerHeight: CGFloat = 24
  static let buttonHeight: CGFloat = 44
  static let buttonSafeAreaInterval: CGFloat = 30
  static let checkerComponentInterval: CGFloat = 21
}
