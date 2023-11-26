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
    // TODO: Mock Data 연결 필요
    guard let jsonPath = Bundle(for: Self.self).path(forResource: "WorkoutSession", ofType: "json"),
          let jsonData = try? Data(contentsOf: .init(filePath: jsonPath))
    else {
      Log.make().error("WorkoutSession Mock Data를 생성할 수 없습니다.")
      return
    }

    let session: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockData: jsonData) : URLSession.shared
    let repository = WorkoutRecordRepository(session: session)
    let useCase = WorkoutRecordUseCase(repository: repository)
    let viewModel = WorkoutSessionContainerViewModel(workoutRecordUseCase: useCase, coordinating: self)
    let viewController = WorkoutSessionContainerViewController(viewModel: viewModel)
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
    navigationController.pushViewController(workoutSummaryViewController, animated: true)
  }
}
