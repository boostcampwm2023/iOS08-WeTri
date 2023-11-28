//
//  CountDownBeforeWorkoutStartTimerUsecase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - CountDownBeforeWorkoutStartTimerUsecaseRepresentable

protocol CountDownBeforeWorkoutStartTimerUsecaseRepresentable: TimerUsecaseRepresentable {
  func beforeWorkoutTimerTextPublisher() -> AnyPublisher<String, Never>
}

// MARK: - CountDownBeforeWorkoutStartTimerUsecase

final class CountDownBeforeWorkoutStartTimerUsecase: TimerUsecase {
  var subscriptions = Set<AnyCancellable>()
  var countDwonBeforeWorkoutStartSubject: PassthroughSubject<Int, Never> = .init()

  /// initDate는 현재 시간보다 미래여야 합니다.
  /// 안그러면 작동하지 않습니다.
  override init(initDate: Date) {
    super.init(initDate: initDate)
  }
}

// MARK: CountDownBeforeWorkoutStartTimerUsecaseRepresentable

extension CountDownBeforeWorkoutStartTimerUsecase: CountDownBeforeWorkoutStartTimerUsecaseRepresentable {
  func beforeWorkoutTimerTextPublisher() -> AnyPublisher<String, Never> {
    intervalCurrentAndInitEverySecondsPublisher()
      .sink { [weak self] value in
        value <= 0
          ? self?.countDwonBeforeWorkoutStartSubject.send(completion: .finished)
          : self?.countDwonBeforeWorkoutStartSubject.send(value)
      }
      .store(in: &subscriptions)

    return countDwonBeforeWorkoutStartSubject
      .map(\.description)
      .eraseToAnyPublisher()
  }

  func beforeStartingWorkoutTime() -> Double {
    return initDate.timeIntervalSince(.now)
  }
}
