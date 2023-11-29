//
//  OneSecondsTimerUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - OneSecondsTimerUseCaseRepresentable

protocol OneSecondsTimerUseCaseRepresentable: TimerUseCaseRepresentable {
  func oneSecondsTimerPublisher() -> AnyPublisher<Int, Never>
}

// MARK: - OneSecondsTimerUseCase

final class OneSecondsTimerUseCase: TimerUseCase {
  override init(initDate: Date, timerPeriod: Double = 1) {
    super.init(initDate: initDate, timerPeriod: timerPeriod)
  }
}

// MARK: OneSecondsTimerUseCaseRepresentable

extension OneSecondsTimerUseCase: OneSecondsTimerUseCaseRepresentable {
  func oneSecondsTimerPublisher() -> AnyPublisher<Int, Never> {
    startTimer()
    return intervalCurrentAndInitEverySecondsPublisher()
      .map { abs($0) }
      .eraseToAnyPublisher()
  }
}
