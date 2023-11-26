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
          self?.startIsMatchedRandomPeer(every: 2)
          self?.cancelPeerRandomMatching(after: 150)
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
    useCase
      .isMatchedRandomPeer(workoutTypeCode: workoutSetting.workoutType.typeCode)
      .receive(on: RunLoop.main)
      .sink { [weak self] result in
        switch result {
        case let .success(dto):
          if dto == nil {
            break
          }
        case .failure:
          self?.coordinating?.popPeerRandomMatchingViewController()
        }
      }
      .store(in: &subscriptions)
  }

  private func cancelPeerRandomMatching() {
    useCase.matchCancel()
    coordinating?.popPeerRandomMatchingViewController()
  }
}
