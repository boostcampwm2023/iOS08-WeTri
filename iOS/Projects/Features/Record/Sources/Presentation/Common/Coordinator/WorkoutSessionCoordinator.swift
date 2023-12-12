//
//  WorkoutSessionCoordinator.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/26/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Log
import Trinet
import UIKit

// MARK: - WorkoutSessionDependency

protocol WorkoutSessionDependency: WorkoutSessionUseCaseDependency,
  WorkoutSocketRepositoryDependency,
  WorkoutSessionViewModelDependency,
  WorkoutSessionViewControllerDependency {}

// MARK: - WorkoutSessionComponents

/// WorkoutSession을 진행하기 윈한 컴포넌트 요소입니다.
struct WorkoutSessionComponents: WorkoutSessionDependency {
  /// 참여하는 팀원들에 대한 배열입니다.
  let participants: [SessionPeerType]

  /// 매칭 시작 시간을 알 수 있습니다.
  let startDate: Date

  /// 서버로 부터 RoomID
  let roomID: String

  /// 서버로 부터 Public ID를 전달 받습니다.
  let id: String

  /// 어떤 운동인지 알 수 있습니다.
  let workoutTypeCode: WorkoutType

  /// 실제 사용자(기기 사용자)의 닉네임 입니다.
  let nickname: String

  /// 실제 사용자(기기 사용자)의 프로필 이미지 URL 입니다.
  let userProfileImage: URL?

  /// 사용자의 workoutMode를 판별해주는 변수 입니다.
  ///
  /// 솔로와, 랜덤매칭이 있습니다.
  let workoutMode: WorkoutMode

  init(
    participants: [SessionPeerType],
    startDate: Date,
    roomID: String,
    id: String,
    workoutTypeCode: WorkoutType,
    nickname: String,
    userProfileImage: URL?,
    workoutMode: WorkoutMode
  ) {
    self.participants = participants
    self.startDate = startDate
    self.roomID = roomID
    self.id = id
    self.workoutTypeCode = workoutTypeCode
    self.nickname = nickname
    self.userProfileImage = userProfileImage
    self.workoutMode = workoutMode
  }

  /// 서버에서 받아오는 String String으로 만들어진 Date값을 Formatter을 활용하여 Date로 바꾸었습니다.
  init(
    participants: [SessionPeerType],
    startDate: String,
    roomID: String,
    id: String,
    workoutTypeCode: WorkoutType,
    nickname: String,
    userProfileImage: URL?,
    workoutMode: WorkoutMode
  ) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = .init(identifier: "ko_KR")
    let date = formatter.date(from: startDate)

    self.startDate = date ?? .now + 4
    self.participants = participants
    self.roomID = roomID
    self.id = id
    self.workoutTypeCode = workoutTypeCode
    self.nickname = nickname
    self.userProfileImage = userProfileImage
    self.workoutMode = workoutMode
  }
}

// MARK: - WorkoutSessionFinishDelegate

public protocol WorkoutSessionFinishDelegate: AnyObject {
  func moveToMainRecord()
}

// MARK: - WorkoutSessionCoordinator

final class WorkoutSessionCoordinator: WorkoutSessionCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  private weak var sessionFinishDelegate: WorkoutSessionFinishDelegate?
  var flow: CoordinatorFlow = .workout
  private let isMockEnvironment: Bool
  private let workoutSessionComponents: WorkoutSessionComponents

  init(
    navigationController: UINavigationController,
    sessionFinishDelegate: WorkoutSessionFinishDelegate?,
    isMockEnvironment: Bool,
    workoutSessionComponents: WorkoutSessionComponents
  ) {
    self.navigationController = navigationController
    self.sessionFinishDelegate = sessionFinishDelegate
    self.isMockEnvironment = isMockEnvironment
    self.workoutSessionComponents = workoutSessionComponents
  }

  func start() {
    pushCountDownBeforeWorkout()
  }

  func pushWorkoutSession() {
    guard let jsonPath = Bundle(for: Self.self).path(forResource: "WorkoutSession", ofType: "json"),
          let jsonData = try? Data(contentsOf: .init(filePath: jsonPath))
    else {
      Log.make().error("WorkoutSession Mock Data를 생성할 수 없습니다.")
      return
    }

    let healthRepository = HealthRepository()

    let socketSession = makeSocketSessionBy(workoutMode: workoutSessionComponents.workoutMode)
    let socketRepository = WorkoutSocketRepository(session: socketSession, dependency: workoutSessionComponents)

    let sessionUseCase = WorkoutSessionUseCase(
      healthRepository: healthRepository,
      socketRepository: socketRepository,
      dependency: workoutSessionComponents
    )

    let sessionViewModel = WorkoutSessionViewModel(useCase: sessionUseCase)
    let sessionViewController = WorkoutSessionViewController(viewModel: sessionViewModel, dependency: workoutSessionComponents)

    let kalmanUseCase = KalmanUseCase()
    let locationPathUseCase = LocationPathUseCase()
    let routeMapViewModel = WorkoutRouteMapViewModel(kalmanUseCase: kalmanUseCase, locationPathUseCase: locationPathUseCase)
    let routeMapViewController = WorkoutRouteMapViewController(viewModel: routeMapViewModel)

    let session: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockData: jsonData) : URLSession.shared
    let repository = WorkoutRecordRepository(session: session)
    let useCase = WorkoutRecordUseCase(repository: repository)
    let oneSecondsTimerUseCase = OneSecondsTimerUseCase(initDate: .now)
    let uploadUseCase = MapImageUploadUseCase(repository: MapImageUploadRepository(session: session))
    let viewModel = WorkoutSessionContainerViewModel(
      workoutRecordUseCase: useCase,
      oneSecondsTimerUseCase: oneSecondsTimerUseCase,
      imageUploadUseCase: uploadUseCase,
      coordinating: self,
      dependency: workoutSessionComponents
    )

    let viewController = WorkoutSessionContainerViewController(
      viewModel: viewModel,
      healthDataProtocol: sessionViewController,
      locationTrackingProtocol: routeMapViewController
    )
    viewController.hidesBottomBarWhenPushed = true

    navigationController.setViewControllers([viewController], animated: true)
  }

  func pushWorkoutSummaryViewController(recordID: Int) {
    guard let jsonPath = Bundle(for: Self.self).path(forResource: "WorkoutSummary", ofType: "json"),
          let jsonData = try? Data(contentsOf: .init(filePath: jsonPath))
    else {
      Log.make().error("WorkoutSummary Mock Data를 생성할 수 없습니다.")
      return
    }

    let session: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockData: jsonData, mockResponse: .init()) : URLSession.shared
    let repository = WorkoutSummaryRepository(session: session)
    let useCase = WorkoutSummaryUseCase(repository: repository, workoutRecordID: recordID)
    let viewModel = WorkoutSummaryViewModel(coordinating: self, workoutSummaryUseCase: useCase)
    let workoutSummaryViewController = WorkoutSummaryViewController(viewModel: viewModel)
    workoutSummaryViewController.hidesBottomBarWhenPushed = true

    navigationController.setViewControllers([workoutSummaryViewController], animated: true)
  }

  func pushCountDownBeforeWorkout() {
    // TODO: CountDown 관련 ViewController 생성
    let useCase = CountDownBeforeWorkoutStartTimerUseCase(initDate: workoutSessionComponents.startDate)

    let viewModel = CountDownBeforeWorkoutViewModel(coordinator: self, useCase: useCase)

    let viewController = CountDownBeforeWorkoutViewController(viewModel: viewModel)
    viewController.hidesBottomBarWhenPushed = true

    navigationController.setViewControllers([viewController], animated: true)
  }

  func setToMainRecord() {
    finish()
    sessionFinishDelegate?.moveToMainRecord()
  }
}

private extension WorkoutSessionCoordinator {
  func makeSocketSessionBy(workoutMode: WorkoutMode) -> URLSessionWebSocketProtocol {
    switch workoutMode {
    case .solo:
      return MockWebSocketSession<WorkoutRealTimeModel>()
    case .random:
      return URLSession.shared
    }
  }
}
