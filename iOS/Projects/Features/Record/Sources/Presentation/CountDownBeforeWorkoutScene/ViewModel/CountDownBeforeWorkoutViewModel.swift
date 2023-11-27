//
//  CountDownBeforeWorkoutViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/27/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log

// MARK: - CountDownBeforeWorkoutViewModelInput

public struct CountDownBeforeWorkoutViewModelInput {
  let viewDidApperPubilsehr: AnyPublisher<Void, Never>
}

public typealias CountDownBeforeWorkoutViewModelOutput = AnyPublisher<CountDownBeforeWorkoutState, Never>

// MARK: - CountDownBeforeWorkoutState

public enum CountDownBeforeWorkoutState {
  case updateMessage(message: String)
  case idle
}

// MARK: - CountDownBeforeWorkoutViewModelRepresentable

protocol CountDownBeforeWorkoutViewModelRepresentable {
  func transform(input: CountDownBeforeWorkoutViewModelInput) -> CountDownBeforeWorkoutViewModelOutput
}

// MARK: - CountDownBeforeWorkoutViewModel

final class CountDownBeforeWorkoutViewModel {
  // MARK: - Properties

  weak var coordinator: WorkoutEnvironmentSetUpCoordinator?
  // TODO: 차후 생성 시점에서 시작 시간을 넘길 예정
  private let workoutInitTime: Date = .now + 8
  private var subscriptions: Set<AnyCancellable> = []
  private var beforeWorkoutTimerSubject: CurrentValueSubject<String, Never> = .init("")
  init(coordinator: WorkoutEnvironmentSetUpCoordinator) {
    self.coordinator = coordinator
  }
}

// MARK: CountDownBeforeWorkoutViewModelRepresentable

extension CountDownBeforeWorkoutViewModel: CountDownBeforeWorkoutViewModelRepresentable {
  public func transform(input: CountDownBeforeWorkoutViewModelInput) -> CountDownBeforeWorkoutViewModelOutput {
    subscriptions.removeAll()

    input
      .viewDidApperPubilsehr
      .sink { [weak self] _ in
        self?.setTimer()
      }
      .store(in: &subscriptions)

    let timerMessagePublisher = beforeWorkoutTimerSubject
      .map { message -> CountDownBeforeWorkoutState in
        return .updateMessage(message: message)
      }
      .eraseToAnyPublisher()

    let initialState: CountDownBeforeWorkoutViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: timerMessagePublisher).eraseToAnyPublisher()
  }
}

private extension CountDownBeforeWorkoutViewModel {
  func bindTimerSubject() {
    beforeWorkoutTimerSubject
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] result in
        switch result {
        case .failure,
             .finished:
          // TODO: 빠져 나오는 로직 작성
          self?.coordinator?.finishDelegate
        }
      }, receiveValue: { [weak self] text in
        Log.make().debug("timerSubject: \(text)")
        self?.beforeWorkoutTimerSubject.send(text)
      })
      .store(in: &subscriptions)
  }

  func beforeStartingWorkoutTime() -> Double {
    return workoutInitTime.timeIntervalSince(.now)
  }

  /// 뷰컨트롤러의 던져줄 타이머에 관해서 세팅합니다.
  func setTimer() {
    Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self else { return }
        let beforeTime = beforeStartingWorkoutTime()
        let firstMumberMilisecondsFromNow = String(format: "%.1f", beforeStartingWorkoutTime()).suffix(1)
        if firstMumberMilisecondsFromNow == "0" {
          let message = Int(beforeTime).description
          // 중요 만약 던지는 뷰에 전달해야 할 타이머 숫자가 0 이라면, timerSubject의 complet시킨다.
          message != "0" ? beforeWorkoutTimerSubject.send(message) : beforeWorkoutTimerSubject.send(completion: .finished)
        }
      }
      .store(in: &subscriptions)
  }

  enum Consts {
    static let timerInitValue = 1
    static let timerEndValue = 3
  }
}
