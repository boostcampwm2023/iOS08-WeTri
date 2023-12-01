//
//  RecordFeatureCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Log
import Trinet
import UIKit

// MARK: - RecordFeatureCoordinator

public final class RecordFeatureCoordinator: RecordFeatureCoordinating {
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinating] = []
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var flow: CoordinatorFlow = .workoutSetting

  private let isMockEnvironment: Bool

  public init(
    navigationController: UINavigationController,
    isMockEnvironment: Bool
  ) {
    self.navigationController = navigationController
    self.isMockEnvironment = isMockEnvironment
  }

  public func start() {
    guard let jsonPath = Bundle(for: Self.self).path(forResource: "Records", ofType: "json"),
          let jsonData = try? Data(contentsOf: .init(filePath: jsonPath))
    else {
      Log.make().error("Records Mock 데이터를 생성할 수 없습니다.")
      return
    }

    let session: URLSessionProtocol = isMockEnvironment ? MockURLSession(mockData: jsonData) : URLSession.shared

    let dateProvideUseCase = DateProvideUseCase()
    let recordCalendarViewModel = RecordCalendarViewModel(dateProvideUseCase: dateProvideUseCase)
    let recordCalendarViewCotnroller = RecordCalendarViewController(viewModel: recordCalendarViewModel)

    let workoutRecordsRepository = WorkoutRecordsRepository(session: session)
    let recordUpdateUseCase = RecordUpdateUseCase(workoutRecordsRepository: workoutRecordsRepository)
    let recordListViewModel = RecordListViewModel(
      recordUpdateUsecase: recordUpdateUseCase,
      dateProvideUsecase: dateProvideUseCase,
      coordinator: self
    )
    let recordListViewController = RecordListViewController(viewModel: recordListViewModel)

    let recordContainerViewController = RecordContainerViewController(
      recordCalendarViewController: recordCalendarViewCotnroller,
      recordListViewController: recordListViewController
    )
    navigationController.pushViewController(recordContainerViewController, animated: false)
  }

  func showSettingFlow() {
    let workoutSettingCoordinator = WorkoutEnvironmentSetUpCoordinator(navigationController: navigationController)
    childCoordinators.append(workoutSettingCoordinator)
    workoutSettingCoordinator.finishDelegate = self
    workoutSettingCoordinator.settingDidFinishedDelegate = self
    workoutSettingCoordinator.start()
  }

  func showWorkoutFlow(workoutSetting _: WorkoutSetting) {
    let coordinator = WorkoutSessionCoordinator(navigationController: navigationController, isMockEnvironment: true)
    childCoordinators.append(coordinator)
    coordinator.finishDelegate = self
    coordinator.start()
  }
}

// MARK: CoordinatorFinishDelegate

extension RecordFeatureCoordinator: CoordinatorFinishDelegate {
  public func flowDidFinished(childCoordinator: Coordinating) {
    childCoordinators = childCoordinators.filter {
      $0.flow != childCoordinator.flow
    }
    navigationController.popToRootViewController(animated: false)
  }
}

// MARK: WorkoutSettingCoordinatorFinishDelegate

extension RecordFeatureCoordinator: WorkoutSettingCoordinatorFinishDelegate {
  func workoutSettingCoordinatorDidFinished(workoutSetting: WorkoutSetting) {
    showWorkoutFlow(workoutSetting: workoutSetting)
  }
}
