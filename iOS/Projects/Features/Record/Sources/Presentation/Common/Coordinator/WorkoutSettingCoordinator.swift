//
//  WorkoutSettingCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Log
import Trinet
import UIKit

// MARK: - WorkoutSettingCoordinator

final class WorkoutSettingCoordinator: WorkoutSettingCoordinating {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinating] = []
  weak var finishDelegate: CoordinatorFinishDelegate?
  var flow: CoordinatorFlow = .workoutSetting
  weak var settingDidFinishedDelegate: WorkoutSettingCoordinatorFinishDelegate?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    pushWorkoutEnvironmentSetupViewController()
  }

  func pushWorkoutSelectViewController() {
    let workoutSelectViewController = WorkoutSelectViewController()
    navigationController.pushViewController(workoutSelectViewController, animated: false)
  }

  func pushWorkoutEnvironmentSetupViewController() {
    let repository = WorkoutEnvironmentSetupNetworkRepository(session: URLSession.shared)

    let useCase = WorkoutEnvironmentSetupUseCase(repository: repository)

    let viewModel = WorkoutEnvironmentSetupViewModel(useCase: useCase, coordinator: self)

    let viewController = WorkoutEnvironmentSetupViewController(viewModel: viewModel)

    navigationController.pushViewController(viewController, animated: false)
  }

  func pushPeerRandomMatchingViewController(workoutSetting: WorkoutSetting) {
    let repository = WorkoutPeerRandomMatchingRepository(session: makeMockDataFromRnaomMatching())

    let useCase = WorkoutPeerRandomMatchingUseCase(repository: repository)

    let viewModel = WorkoutPeerRandomMatchingViewModel(workoutSetting: workoutSetting, coordinating: self, useCase: useCase)

    let viewController = WorkoutPeerRandomMatchingViewController(viewModel: viewModel)

    viewController.modalPresentationStyle = .overFullScreen
    viewController.modalTransitionStyle = .crossDissolve
    navigationController.present(viewController, animated: true)
  }

  func popPeerRandomMatchingViewController() {
    navigationController.dismiss(animated: true)
  }

  func pushCountdownViewController(workoutSetting _: WorkoutSetting) {
    // TODO: 뷰 컨트롤러 시작 로직 작성
  }

  func finish(workoutSetting: WorkoutSetting) {
    settingDidFinishedDelegate?.workoutSettingCoordinatorDidFinished(workoutSetting: workoutSetting)
  }
}

private extension WorkoutSettingCoordinator {
  func makeMockDataFromRnaomMatching() -> URLSessionProtocol {
    let mockSession = MockURLSession(mockDataByURLString: makeMockDataFromRnaomMatchingDataByURLString())
    return mockSession
  }

  func makeMockDataFromRnaomMatchingDataByURLString() -> [String: Data] {
    let serverURL = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
    let res = [
      "\(serverURL)/\(PersistencyProperty.matchStartPath)": mockDataMatchStart(),
      "\(serverURL)/\(PersistencyProperty.matchCancellPath)": mockDataMatchStart(),
      "\(serverURL)/\(PersistencyProperty.matchesRandomPath)": mockDataRandomMatching(),
    ]
    return res
  }

  func mockDataMatchStart() -> Data {
    guard
      let bundle = Bundle(identifier: PersistencyProperty.bundleIdentifier),
      let path = bundle.path(forResource: PersistencyProperty.matchStart, ofType: PersistencyProperty.peerTypesFileNameOfType),
      let data = try? Data(contentsOf: URL(filePath: path))
    else {
      return Data()
    }
    return data
  }

  func mockDataMatchCancel() -> Data {
    guard
      let bundle = Bundle(identifier: PersistencyProperty.bundleIdentifier),
      let path = bundle.path(forResource: PersistencyProperty.matchCancel, ofType: PersistencyProperty.peerTypesFileNameOfType),
      let data = try? Data(contentsOf: URL(filePath: path))
    else {
      return Data()
    }
    return data
  }

  func mockDataRandomMatching() -> Data {
    guard
      let bundle = Bundle(identifier: PersistencyProperty.bundleIdentifier),
      let path = bundle.path(forResource: PersistencyProperty.matchesRandom, ofType: PersistencyProperty.peerTypesFileNameOfType),
      let data = try? Data(contentsOf: URL(filePath: path))
    else {
      return Data()
    }
    return data
  }

  var serverURL: String {
    Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
  }

  private enum PersistencyProperty {
    static let bundleIdentifier = "kr.codesquad.boostcamp8.RecordFeature"

    static let matchStart = "MatchesStart"
    static let matchStartPath = "matches/start"

    static let matchCancel = "matchesCancel"
    static let matchCancellPath = "matches/cancle"

    static let matchesRandom = "MatchesRandom"
    static let matchesRandomPath = "matches/random"

    static let peerTypesFileNameOfType = "json"
  }
}
