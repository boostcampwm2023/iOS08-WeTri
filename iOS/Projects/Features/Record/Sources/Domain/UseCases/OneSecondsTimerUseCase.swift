//
//  OneSecondsTimerUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Log

// MARK: - OneSecondsTimerUseCaseRepresentable

protocol OneSecondsTimerUseCaseRepresentable: TimerUseCaseRepresentable {
  func oneSecondsTimerPublisher() -> AnyPublisher<Int, Never>
}

// MARK: - OneSecondsTimerUseCase

final class OneSecondsTimerUseCase: TimerUseCase {
  override init(initDate: Date, timerPeriod: Double = 1) {
    super.init(initDate: initDate, timerPeriod: timerPeriod)
    startTimer()
  }
}

// MARK: OneSecondsTimerUseCaseRepresentable

extension OneSecondsTimerUseCase: OneSecondsTimerUseCaseRepresentable {
  func oneSecondsTimerPublisher() -> AnyPublisher<Int, Never> {
    return intervalCurrentAndInitEverySecondsPublisher()
      .map { abs($0) }
      .eraseToAnyPublisher()
  }
}
