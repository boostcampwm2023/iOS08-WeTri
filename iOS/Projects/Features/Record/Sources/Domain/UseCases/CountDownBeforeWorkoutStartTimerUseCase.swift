//
//  CountDownBeforeWorkoutStartTimerUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - CountDownBeforeWorkoutStartTimerUseCaseRepresentable

protocol CountDownBeforeWorkoutStartTimerUseCaseRepresentable: TimerUseCaseRepresentable {
  func beforeWorkoutTimerTextPublisher() -> AnyPublisher<String, Never>
}

// MARK: - CountDownBeforeWorkoutStartTimerUseCase

final class CountDownBeforeWorkoutStartTimerUseCase: TimerUseCase {
  private var subscriptions = Set<AnyCancellable>()
  private var countDownBeforeWorkoutStartSubject: PassthroughSubject<Int, Never> = .init()

  /// initDate는 현재 시간보다 미래여야 합니다.
  /// 안그러면 작동하지 않습니다.
  override init(initDate: Date, timerPeriod _: Double = 1) {
    super.init(initDate: initDate)
  }
}

// MARK: CountDownBeforeWorkoutStartTimerUseCaseRepresentable

extension CountDownBeforeWorkoutStartTimerUseCase: CountDownBeforeWorkoutStartTimerUseCaseRepresentable {
  func beforeWorkoutTimerTextPublisher() -> AnyPublisher<String, Never> {
    startTimer()
    intervalCurrentAndInitEverySecondsPublisher()
      .sink { [weak self] value in
        value <= 0
          ? self?.countDownBeforeWorkoutStartSubject.send(completion: .finished)
          : self?.countDownBeforeWorkoutStartSubject.send(value)
      }
      .store(in: &subscriptions)

    return countDownBeforeWorkoutStartSubject
      .map(\.description)
      .eraseToAnyPublisher()
  }
}
