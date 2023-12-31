//
//  WorkoutEnvironmentSetupViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutEnvironmentSetupViewModelInput

struct WorkoutEnvironmentSetupViewModelInput {
  let requestWorkoutTypes: AnyPublisher<Void, Never>
  let requestWorkoutPeerTypes: AnyPublisher<Void, Never>
  let endWorkoutEnvironment: AnyPublisher<Void, Never>
  let selectWorkoutType: AnyPublisher<WorkoutType?, Never>
  let selectPeerType: AnyPublisher<PeerType?, Never>
  let didTapStartButton: AnyPublisher<Void, Never>
}

typealias WorkoutEnvironmentSetupViewModelOutput = AnyPublisher<WorkoutEnvironmentState, Never>

// MARK: - WorkoutEnvironmentState

enum WorkoutEnvironmentState {
  case idle
  case workoutTypes([WorkoutType])
  case workoutPeerTypes([PeerType])
  case didSelectWorkoutType(Bool)
  case didSelectWorkoutPeerType(Bool)

  case error(WorkoutEnvironmentErrorState)
}

// MARK: - WorkoutEnvironmentErrorState

enum WorkoutEnvironmentErrorState: LocalizedError {
  case unknownError
}

// MARK: - WorkoutEnvironmentSetupViewModelRepresentable

protocol WorkoutEnvironmentSetupViewModelRepresentable {
  func transform(input: WorkoutEnvironmentSetupViewModelInput) -> WorkoutEnvironmentSetupViewModelOutput
}

// MARK: - WorkoutEnvironmentSetupViewModel

final class WorkoutEnvironmentSetupViewModel {
  private var subscriptions = Set<AnyCancellable>()
  private let workoutEnvironmentSetupUseCase: WorkoutEnvironmentSetupUseCaseRepresentable
  private let userInformationUseCase: UserInformationUseCaseRepresentable

  private weak var coordinator: WorkoutEnvironmentSetUpCoordinating?

  var didSelectWorkoutType: WorkoutType?
  var didSelectWorkoutPeerType: PeerType?

  var workoutTypes: [WorkoutType] = []

  init(
    workoutEnvironmentSetupUseCase: WorkoutEnvironmentSetupUseCaseRepresentable,
    userInformationUseCase: UserInformationUseCaseRepresentable,
    coordinator: WorkoutEnvironmentSetUpCoordinator?
  ) {
    self.workoutEnvironmentSetupUseCase = workoutEnvironmentSetupUseCase
    self.coordinator = coordinator
    self.userInformationUseCase = userInformationUseCase
  }
}

// MARK: WorkoutEnvironmentSetupViewModelRepresentable

extension WorkoutEnvironmentSetupViewModel: WorkoutEnvironmentSetupViewModelRepresentable {
  func transform(input: WorkoutEnvironmentSetupViewModelInput) -> WorkoutEnvironmentSetupViewModelOutput {
    subscriptions.removeAll()

    let workoutTypes: WorkoutEnvironmentSetupViewModelOutput = input
      .requestWorkoutTypes
      .flatMap(workoutEnvironmentSetupUseCase.workoutTypes)
      .map { results -> WorkoutEnvironmentState in
        switch results {
        case let .success(workoutTypes):
          let uniquePeerTypes = Array(Set(workoutTypes))
          return .workoutTypes(uniquePeerTypes)
        case .failure:
          return .error(.unknownError)
        }
      }.eraseToAnyPublisher()

    let workoutPeerType: WorkoutEnvironmentSetupViewModelOutput = input
      .requestWorkoutPeerTypes
      .flatMap { [workoutEnvironmentSetupUseCase] _ -> AnyPublisher<Result<[PeerType], Error>, Never> in
        return workoutEnvironmentSetupUseCase.peerTypes()
      }
      .map { results -> WorkoutEnvironmentState in
        switch results {
        case let .success(peerTypes):
          let uniquePeerTypes = Array(Set(peerTypes))
          return .workoutPeerTypes(uniquePeerTypes)
        case .failure:
          return .error(.unknownError)
        }
      }.eraseToAnyPublisher()

    let didSelectWorkoutPeerType: WorkoutEnvironmentSetupViewModelOutput = input
      .selectPeerType
      .map { [weak self] peerType -> WorkoutEnvironmentState in
        guard let self else {
          return .error(.unknownError)
        }
        if let peerType {
          self.didSelectWorkoutPeerType = peerType
          return .didSelectWorkoutPeerType(true)
        }
        return .didSelectWorkoutPeerType(false)
      }.eraseToAnyPublisher()

    let didSelectWorkoutType: WorkoutEnvironmentSetupViewModelOutput = input
      .selectWorkoutType
      .map { [weak self] workoutType -> WorkoutEnvironmentState in
        guard let self else {
          return .error(.unknownError)
        }
        if let workoutType {
          self.didSelectWorkoutType = workoutType
          return .didSelectWorkoutType(true)
        }
        return .didSelectWorkoutType(false)
      }.eraseToAnyPublisher()

    input
      .didTapStartButton
      .sink { [weak self] _ in
        self?.didTapStartButton()
      }.store(in: &subscriptions)

    let idle: WorkoutEnvironmentSetupViewModelOutput = Just(WorkoutEnvironmentState.idle).eraseToAnyPublisher()

    return Publishers.MergeMany(workoutTypes, idle, workoutPeerType, didSelectWorkoutType, didSelectWorkoutPeerType).eraseToAnyPublisher()
  }

  private func didTapStartButton() {
    guard
      let didSelectWorkoutType,
      let didSelectWorkoutPeerType,
      let mode = WorkoutPeerTypeCodeToModeString(rawValue: didSelectWorkoutPeerType.typeCode)
    else {
      return
    }

    let workoutSetting = WorkoutSetting(workoutType: didSelectWorkoutType, workoutPeerType: didSelectWorkoutPeerType)

    switch mode {
    case .solo:
      let sessionPeerTypeOfMe = SessionPeerType(
        nickname: userInformationUseCase.userNickName(),
        id: "",
        profileImageURL: userInformationUseCase.userProfileImageURL()
      )
      coordinator?.finish(
        workoutSessionComponents: .init(
          participants: [sessionPeerTypeOfMe],
          startDate: .now + 6,
          roomID: "",
          id: "",
          workoutTypeCode: workoutSetting.workoutType,
          nickname: userInformationUseCase.userNickName(),
          userProfileImage: userInformationUseCase.userProfileImageURL(),
          workoutMode: .solo
        )
      )
    case .random:
      coordinator?.pushPeerRandomMatchingViewController(workoutSetting: workoutSetting)
    }
  }

  private enum WorkoutPeerTypeCodeToModeString: Int {
    case solo = 1
    case random = 2
  }
}

// MARK: - ViewModelError

enum ViewModelError: LocalizedError {
  case viewModelDidDeinit
}
