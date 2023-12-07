//
//  WorkoutEnvironmentSetUpCoordinator.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/20.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Log
import Trinet
import UIKit

// MARK: - WorkoutEnvironmentSetUpCoordinator

final class WorkoutEnvironmentSetUpCoordinator: WorkoutEnvironmentSetUpCoordinating {
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
    let userInfoUseCase = UserInformationUseCase()

    let viewModel = WorkoutEnvironmentSetupViewModel(
      workoutEnvironmentSetupUseCase: useCase,
      userInformationUseCase: userInfoUseCase,
      coordinator: self
    )

    let viewController = WorkoutEnvironmentSetupViewController(viewModel: viewModel)

    navigationController.pushViewController(viewController, animated: false)
  }

  func pushPeerRandomMatchingViewController(workoutSetting: WorkoutSetting) {
    let repository = WorkoutPeerRandomMatchingRepository(session: URLSession.shared)

    let workoutPeerRandomMatchingUseCase = WorkoutPeerRandomMatchingUseCase(repository: repository)
    let userInformationUseCase = UserInformationUseCase()

    let viewModel = WorkoutPeerRandomMatchingViewModel(
      workoutSetting: workoutSetting,
      coordinating: self,
      workoutPeerRandomMatchingUseCase: workoutPeerRandomMatchingUseCase,
      userInformationUseCase: userInformationUseCase
    )

    let viewController = WorkoutPeerRandomMatchingViewController(viewModel: viewModel)

    viewController.modalPresentationStyle = .overFullScreen
    viewController.modalTransitionStyle = .crossDissolve
    navigationController.present(viewController, animated: true)
  }

  func popPeerRandomMatchingViewController() {
    navigationController.dismiss(animated: true)
  }

  func finish(workoutSessionComponents: WorkoutSessionComponents) {
    settingDidFinishedDelegate?.workoutSettingCoordinatorDidFinished(workoutSessionComponents: workoutSessionComponents)
  }
}

private extension WorkoutEnvironmentSetUpCoordinator {
  func makeMockDataFromRandomMatching() -> URLSessionProtocol {
    let mockSession = MockURLSession(mockDataByURLString: makeMockDataFromRandomMatchingDataByURLString())
    return mockSession
  }

  func makeMockDataFromRandomMatchingDataByURLString() -> [String: Data] {
    let serverURL = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
    let res = [
      "\(serverURL)/\(PersistencyProperty.matchStartPath)": mockDataMatchStart(),
      "\(serverURL)/\(PersistencyProperty.matchCancelPath)": mockDataMatchStart(),
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
    static let matchStartPath = "api/v1/matches/start"

    static let matchCancel = "matchesCancel"
    static let matchCancelPath = "api/v1/matches/cancel"

    static let matchesRandom = "MatchesRandom"
    static let matchesRandomPath = "api/v1/matches/random"

    static let peerTypesFileNameOfType = "json"
  }
}
