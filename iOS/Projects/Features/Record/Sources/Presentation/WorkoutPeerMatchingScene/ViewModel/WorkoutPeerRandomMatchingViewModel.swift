//
//  WorkoutPeerRandomMatchingViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutPeerRandomMatchingViewModelInput

public struct WorkoutPeerRandomMatchingViewModelInput {
  let cancelPublisher: AnyPublisher<Void, Never>
}

public typealias WorkoutPeerRandomMatchingViewModelOutput = AnyPublisher<WorkoutPeerRandomMatchingState, Never>

// MARK: - WorkoutPeerRandomMatchingState

public enum WorkoutPeerRandomMatchingState {
  case idle
}

// MARK: - WorkoutPeerRandomMatchingViewModelRepresentable

protocol WorkoutPeerRandomMatchingViewModelRepresentable {
  func transform(input: WorkoutPeerRandomMatchingViewModelInput) -> WorkoutPeerRandomMatchingViewModelOutput
}

// MARK: - WorkoutPeerRandomMatchingViewModel

final class WorkoutPeerRandomMatchingViewModel {
  // MARK: - Properties

  private weak var coordinating: WorkoutEnvironmentSetUpCoordinating?
  private var useCase: WorkoutPeerRandomMatchingUseCaseRepresentable
  private let workoutSetting: WorkoutSetting
  private var timerInitDate: Date?

  init(
    workoutSetting: WorkoutSetting,
    coordinating: WorkoutEnvironmentSetUpCoordinating,
    useCase: WorkoutPeerRandomMatchingUseCaseRepresentable
  ) {
    self.coordinating = coordinating
    self.useCase = useCase
    self.workoutSetting = workoutSetting
  }

  private var didMatchStartedDate = Date.now
  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: WorkoutPeerRandomMatchingViewModelRepresentable

extension WorkoutPeerRandomMatchingViewModel: WorkoutPeerRandomMatchingViewModelRepresentable {
  public func transform(input: WorkoutPeerRandomMatchingViewModelInput) -> WorkoutPeerRandomMatchingViewModelOutput {
    subscriptions.removeAll()

    bindUseCase()

    input
      .cancelPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.cancelPeerRandomMatching()
      }.store(in: &subscriptions)

    let initialState: WorkoutPeerRandomMatchingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }

  private func bindUseCase() {
    useCase.matcheStart(workoutSetting: workoutSetting)
      .receive(on: RunLoop.main)
      .sink { [weak self] results in
        switch results {
        case .failure:
          self?.cancelPeerRandomMatching()
        case .success:
          self?.startIsMatchedRandomPeer(every: Constants.pollingPeroide)
          self?.cancelPeerRandomMatching(after: Constants.maximumCouldWaitTime)
        }
      }
      .store(in: &subscriptions)
  }

  private func cancelPeerRandomMatching(after: Double) {
    let afterStride = RunLoop.SchedulerTimeType.Stride(after)

    Just(())
      .delay(for: afterStride, scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.cancelPeerRandomMatching()
      }.store(in: &subscriptions)
  }

  private func startIsMatchedRandomPeer(every time: Double) {
    Timer.publish(every: time, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.sendIsMatchedRandomPeer()
      }
      .store(in: &subscriptions)
  }

  private func sendIsMatchedRandomPeer() {
    didMatchStartedDate = .now
    Timer.publish(every: 2, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] date in
        guard let self else {
          return
        }
        let waitingTime = Int(date.timeIntervalSince(didMatchStartedDate))
        let request = IsMatchedRandomPeersRequest(workoutID: workoutSetting.workoutType.typeCode, waitingTime: waitingTime)
        requestIsMatchedRandomPeers(request: request)
      }
      .store(in: &subscriptions)
  }

  /// matche를 한다고 계속 요청을 보냅니다.
  /// UseCase쪽에서 매치가 되었다고 한다면,
  ///   매치 성사 되었을 떄:  pushWorkoutSession 함수로 coordinator를 통해서 다음 화면으로 넘어갑니다.
  ///   매치 성사가 안 되었을 때: 2초마다 계속해서 요청을 보냅니다.
  func requestIsMatchedRandomPeers(request: IsMatchedRandomPeersRequest) {
    useCase
      .isMatchedRandomPeer(isMatchedRandomPeersRequest: request)
      .receive(on: RunLoop.main)
      .sink { [weak self] result in
        switch result {
        case let .success(response):
          if response == nil {
            return
          }
          self?.pushWorkoutSession(response: response)
        case .failure:
          self?.coordinating?.popPeerRandomMatchingViewController()
        }
      }
      .store(in: &subscriptions)
  }

  func pushWorkoutSession(response: IsMatchedRandomPeersResponse?) {
    guard
      let response,
      let peersResponse = response.peers,
      let roomID = response.roomID,
      let startDate = response.liveWorkoutStartTime
    else {
      return
    }
    let peers = peersResponse.map { Peer(nickname: $0.nickname, imageURL: $0.publicID) }
    coordinating?.finish(workoutSessionElement: .init(startDateString: startDate, peers: peers, roomID: roomID))
  }

  private func cancelPeerRandomMatching() {
    useCase.matchCancel()
    coordinating?.popPeerRandomMatchingViewController()
  }

  private enum Constants {
    static let pollingPeroide: Double = 2
    static let maximumCouldWaitTime: Double = 150
  }
}
