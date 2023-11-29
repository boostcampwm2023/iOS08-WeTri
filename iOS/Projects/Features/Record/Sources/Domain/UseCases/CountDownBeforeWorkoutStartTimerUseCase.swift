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

protocol CountDownBeforeWorkoutStartTimerUseCaseRepresentable {
  func beforeWorkoutTimerTextPublisher() -> AnyPublisher<String, Never>
  mutating func startTimer()
  mutating func stopTimer()
}

// MARK: - CountDownBeforeWorkoutStartTimerUseCase

struct CountDownBeforeWorkoutStartTimerUseCase {
  let initDate: Date
  var timerCancellable: AnyCancellable?
  let beforeWorkoutTimerTextSubject: CurrentValueSubject<String, Never> = .init("")
  init(initDate: Date) {
    self.initDate = initDate
    timerCancellable = nil
  }
}

// MARK: CountDownBeforeWorkoutStartTimerUseCaseRepresentable

extension CountDownBeforeWorkoutStartTimerUseCase: CountDownBeforeWorkoutStartTimerUseCaseRepresentable {
  func beforeWorkoutTimerTextPublisher() -> AnyPublisher<String, Never> {
    return beforeWorkoutTimerTextSubject.eraseToAnyPublisher()
  }

  func beforeStartingWorkoutTime() -> Double {
    return initDate.timeIntervalSince(.now)
  }

  /// 뷰컨트롤러의 던져줄 타이머에 관해서 세팅합니다.
  mutating func startTimer() {
    timerCancellable = Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
      .autoconnect()
      .sink { [self] _ in
        let beforeTime = beforeStartingWorkoutTime()
        let firstMumberMilisecondsFromNow = String(format: "%.1f", beforeStartingWorkoutTime()).suffix(1)
        if firstMumberMilisecondsFromNow == "0" {
          let message = Int(beforeTime)
          // 중요 만약 던지는 뷰에 전달해야 할 타이머 숫자가 0 이라면, timerSubject의 complet시킨다.
          message != 0
            ? beforeWorkoutTimerTextSubject.send(message.description)
            : beforeWorkoutTimerTextSubject.send(completion: .finished)
        }
      }
  }

  mutating func stopTimer() {
    timerCancellable = nil
  }
}
