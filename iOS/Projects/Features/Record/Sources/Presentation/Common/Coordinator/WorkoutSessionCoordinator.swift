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

// MARK: - WorkoutSessionCoordinator

final class WorkoutSessionCoordinator: WorkoutSessionCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .workout
  private let isMockEnvironment: Bool

  init(navigationController: UINavigationController, isMockEnvironment: Bool) {
    self.navigationController = navigationController
    self.isMockEnvironment = isMockEnvironment
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

    // FIXME: Dependency값을 올바르게 설정해주세요.
    let healthDependency = WorkoutSessionUseCaseDependency(date: .now, roomID: "해시값", id: "자신의 아이디값", nickname: "내 닉네임")
    let healthRepository = HealthRepository()

    // TODO: 같이하기, 혼자하기 모드에 따라 session 주입을 다르게 해야합니다.
    let socketRepository = WorkoutSocketRepository(session: MockWebSocketSession(), roomID: healthDependency.roomID)

    let sessionUseCase = WorkoutSessionUseCase(
      healthRepository: healthRepository,
      socketRepository: socketRepository,
      dependency: healthDependency
    )

    let sessionViewModel = WorkoutSessionViewModel(useCase: sessionUseCase)
    let sessionViewController = WorkoutSessionViewController(viewModel: sessionViewModel, participants: [])

    let session: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockData: jsonData) : URLSession.shared
    let repository = WorkoutRecordRepository(session: session)
    let useCase = WorkoutRecordUseCase(repository: repository)
    let viewModel = WorkoutSessionContainerViewModel(
      workoutRecordUseCase: useCase,
      coordinating: self,
      startDate: healthDependency.date
    )

    let viewController = WorkoutSessionContainerViewController(viewModel: viewModel, healthDataProtocol: sessionViewController)
    navigationController.pushViewController(viewController, animated: true)
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
    let viewModel = WorkoutSummaryViewModel(workoutSummaryUseCase: useCase)
    let workoutSummaryViewController = WorkoutSummaryViewController(viewModel: viewModel)
    navigationController.setViewControllers([workoutSummaryViewController], animated: true)
  }

  func pushCountDownBeforeWorkout() {
    // TODO: CountDown 관련 ViewController 생성
    let useCase = CountDownBeforeWorkoutStartTimerUseCase(initDate: .now + 8)

    let viewModel = CountDownBeforeWorkoutViewModel(coordinator: self, useCase: useCase)

    let viewController = CountDownBeforeWorkoutViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }

  func pushTapBarViewController() {
    // TODO: 코디네이팅 종료에 관한 로직 생성
    finishDelegate?.flowDidFinished(childCoordinator: self)
  }
}
