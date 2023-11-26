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

  private weak var coordinating: WorkoutSettingCoordinating?
  private var useCase: WorkoutPeerRandomMatchingUseCaseRepresentable
  private let workoutSetting: WorkoutSetting
  private var timerInitDate: Date?

  init(
    workoutSetting: WorkoutSetting,
    coordinating: WorkoutSettingCoordinating,
    useCase: WorkoutPeerRandomMatchingUseCaseRepresentable
  ) {
    self.coordinating = coordinating
    self.useCase = useCase
    self.workoutSetting = workoutSetting
  }

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
        self?.useCase.matchCancel()
        self?.coordinating?.popPeerRandomMatchingViewController()
      }.store(in: &subscriptions)

    let initialState: WorkoutPeerRandomMatchingViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }

  func bindUseCase() {
    useCase.matcheStart(workoutSetting: workoutSetting)
      .receive(on: RunLoop.main)
      .sink { [weak self] results in
        switch results {
        case .failure:
          self?.coordinating?.popPeerRandomMatchingViewController()
        case .success:
          self?.startIsMatchedRandomPeer(every: 2)
        }
      }
      .store(in: &subscriptions)
  }

  func startIsMatchedRandomPeer(every time: Double) {
    Timer.publish(every: time, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.sendIsMatchedRandomPeer()
      }
      .store(in: &subscriptions)
  }

  func sendIsMatchedRandomPeer() {
    useCase
      .isMatchedRandomPeer()
      .receive(on: RunLoop.main)
      .sink { [weak self] result in
        switch result {
        case let .success(success):
          break
        case .failure:
          self?.coordinating?.popPeerRandomMatchingViewController()
        }
      }
      .store(in: &subscriptions)
  }
}
