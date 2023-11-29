//
//  OneSecondsTimerUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - OneSecondsTimerUsecaseRepresentable

protocol OneSecondsTimerUsecaseRepresentable: TimerUseCaseRepresentable {
  func oneSecondsTimerPublisher() -> AnyPublisher<Int, Never>
}

// MARK: - OneSecondsTimerUsecase

final class OneSecondsTimerUsecase: TimerUseCase {
  override init(initDate: Date) {
    super.init(initDate: initDate)
    startTimer()
  }
}

// MARK: OneSecondsTimerUsecaseRepresentable

extension OneSecondsTimerUsecase: OneSecondsTimerUsecaseRepresentable {
  func oneSecondsTimerPublisher() -> AnyPublisher<Int, Never> {
    return intervalCurrentAndInitEverySecondsPublisher()
      .map { abs($0) }
      .eraseToAnyPublisher()
  }
}
