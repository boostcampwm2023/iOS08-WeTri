//
//  OnboardingViewController.swift
//  OnboardingFeature
//
//  Created by MaraMincho on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import CombineExtension
import CoreLocation
import DesignSystem
import HealthKit
import Log
import UIKit

// MARK: - OnboardingViewController

public final class OnboardingViewController: UIViewController {
  // MARK: Properties

  private let viewModel: OnboardingViewModelRepresentable

  private let shouldPresentMapAuthorizationSubject: PassthroughSubject<Void, Never> = .init()
  private let shouldPresentHealthAuthorizationSubject: PassthroughSubject<Void, Never> = .init()
  private let finishAuthProcessSubject: PassthroughSubject<Void, Never> = .init()

  private var subscriptions: Set<AnyCancellable> = []

  var locationManager: CLLocationManager? = nil

  // MARK: UI Components

  private let onboardingImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit

    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()

  private let titleTextLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    label.textColor = DesignSystemColor.primaryText
    label.textAlignment = .center
    label.text = "라벨 타이틀 텍스트"
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionTextLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3)
    label.textColor = DesignSystemColor.primaryText
    label.numberOfLines = 2
    label.textAlignment = .center
    label.text = "라벨 타이틀 텍스트"

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let nextButton: UIButton = {
    let button = UIButton(configuration: .plain())
    button.configurationUpdateHandler = UIButton.Configuration.main(label: "다음")

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let authRequestButton: UIButton = {
    let button = UIButton(configuration: .plain())
    button.configurationUpdateHandler = UIButton.Configuration.main(label: "다음")

    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  // MARK: Initializations

  public init(viewModel: OnboardingViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycles

  override public func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    shouldPresentMapAuthorizationSubject.send(())
  }
}

private extension OnboardingViewController {
  func setup() {
    setupStyles()
    setupHierarchyAndConstraints()
    bind()
  }

  func setupHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(onboardingImage)
    onboardingImage.topAnchor
      .constraint(equalTo: safeArea.topAnchor, constant: Metrics.imageAndSafeAreaSpacing).isActive = true
    onboardingImage.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    onboardingImage.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    onboardingImage.heightAnchor.constraint(equalToConstant: Metrics.imageHeight).isActive = true

    view.addSubview(titleTextLabel)
    titleTextLabel.topAnchor
      .constraint(equalTo: onboardingImage.bottomAnchor, constant: Metrics.ImageAndTitleSpacing).isActive = true
    titleTextLabel.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    titleTextLabel.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true

    view.addSubview(descriptionTextLabel)
    descriptionTextLabel.topAnchor
      .constraint(equalTo: titleTextLabel.bottomAnchor, constant: Metrics.titleAndSubtitleSpacing).isActive = true
    descriptionTextLabel.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    descriptionTextLabel.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true

    view.addSubview(nextButton)
    nextButton.bottomAnchor
      .constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.nextButtonBottomToSafeAreaBottomSpacing).isActive = true
    nextButton.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    nextButton.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    nextButton.heightAnchor.constraint(equalToConstant: Metrics.nextButtonHeight).isActive = true

    view.addSubview(authRequestButton)
    authRequestButton.bottomAnchor
      .constraint(equalTo: safeArea.bottomAnchor, constant: -Metrics.nextButtonBottomToSafeAreaBottomSpacing).isActive = true
    authRequestButton.leadingAnchor
      .constraint(equalTo: safeArea.leadingAnchor, constant: ConstraintsGuideLine.value).isActive = true
    authRequestButton.trailingAnchor
      .constraint(equalTo: safeArea.trailingAnchor, constant: -ConstraintsGuideLine.value).isActive = true
    authRequestButton.heightAnchor.constraint(equalToConstant: Metrics.nextButtonHeight).isActive = true
    authRequestButton.isHidden = true
  }

  func setupStyles() {
    view.backgroundColor = .white
  }

  func bind() {
    bindViewModel()
    bindNextButtonDidTap()
    bindAuthRequestButtonDidTap()
  }

  func bindViewModel() {
    let input = OnboardingViewModelInput(
      shouldPresentMapAuthorizationPublisher: shouldPresentMapAuthorizationSubject.eraseToAnyPublisher(),
      shouldPresentHealthAuthorizationPublisher: shouldPresentHealthAuthorizationSubject.eraseToAnyPublisher(),
      finishAuthorizationPublisher: finishAuthProcessSubject.eraseToAnyPublisher()
    )
    viewModel.transform(input: input)
      .sink { [weak self] state in
        self?.applyState(state: state)
      }
      .store(in: &subscriptions)
  }

  func bindNextButtonDidTap() {
    nextButton.publisher(.touchUpInside)
      .map { _ in () }
      .bind(to: shouldPresentHealthAuthorizationSubject)
      .store(in: &subscriptions)
  }

  func bindAuthRequestButtonDidTap() {
    authRequestButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.requestLocationAuth()
      }
      .store(in: &subscriptions)
  }

  func requestLocationAuth() {
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
  }

  func requestHealAuth() {
    let healthStore = HKHealthStore()
    let healthDataTypeValues: Set<HKQuantityType> = [
      HKQuantityType(.heartRate),
      HKQuantityType(.distanceWalkingRunning),
      HKQuantityType(.distanceCycling),
      HKQuantityType(.distanceSwimming),
      HKQuantityType(.activeEnergyBurned),
    ]
    healthStore.requestAuthorization(toShare: nil, read: healthDataTypeValues) { [weak self] _, error in
      self?.finishAuthProcessSubject.send(completion: .finished)
      if let error {
        Log.make(with: .healthKit).error("Received an HealthKit error type: \(error)")
      }
    }
  }

  func applyState(state: OnboardingState) {
    switch state {
    case let .errorState(error):
      Log.make().debug("\(error)")
    case .finish,
         .idle:
      break
    case let .shouldPresentMapAuthorization(onboardingScenePropertyDTO): updateViewProperty(by: onboardingScenePropertyDTO)
    case let .shouldPresentHealthAuthorization(onboardingScenePropertyDTO):
      updateViewProperty(by: onboardingScenePropertyDTO)
      nextButton.isHidden = true
      authRequestButton.isHidden = false
    }
  }

  func updateViewProperty(by dtoProperty: OnboardingScenePropertyResponse) {
    guard let imageData = dtoProperty.imageData else {
      return
    }
    titleTextLabel.text = dtoProperty.titleText
    descriptionTextLabel.text = dtoProperty.descriptionText
    onboardingImage.image = UIImage(data: imageData)
  }

  enum Metrics {
    static let imageAndSafeAreaSpacing: CGFloat = 100
    static let imageHeight: CGFloat = 250
    static let ImageAndTitleSpacing: CGFloat = 45
    static let titleAndSubtitleSpacing: CGFloat = 15
    static let nextButtonBottomToSafeAreaBottomSpacing: CGFloat = 23
    static let nextButtonHeight: CGFloat = 44
  }
}

// MARK: CLLocationManagerDelegate

extension OnboardingViewController: CLLocationManagerDelegate {
  /// 위치정보를 활용에 대한 데이터를 바꾸고 실행하게 합니다.
  public func locationManagerDidChangeAuthorization(_: CLLocationManager) {
    // 헬스 데이터를 요청하기 전, 사용자가 다음 버튼을 누르는 것을 방지합니다.
    authRequestButton.isUserInteractionEnabled = false
    requestHealAuth()
  }
}
