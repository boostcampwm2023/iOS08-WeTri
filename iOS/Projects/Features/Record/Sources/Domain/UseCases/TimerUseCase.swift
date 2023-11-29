//
//  TimerUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//
import Combine
import Foundation
import Log

// MARK: - TimerUseCaseRepresentable

protocol TimerUseCaseRepresentable: AnyObject {
  var initDate: Date { get }
  func intervalCurrentAndInitEverySecondsPublisher() -> AnyPublisher<Int, Never>
  func startTimer()
  func stopTimer()
}

// MARK: - TimerUseCase

class TimerUseCase: TimerUseCaseRepresentable {
  let initDate: Date
  private var miliSecondsTimer: AnyCancellable? = nil
  private var secondsTimer: AnyCancellable? = nil
  private var oneSecondsTimerIsValid: AnyCancellable? = nil
  private var timeIntervalEveryOneSecondsSubject: PassthroughSubject<Int, Never> = .init()

  init(initDate: Date) {
    self.initDate = initDate
  }

  func intervalCurrentAndInitEverySecondsPublisher() -> AnyPublisher<Int, Never> {
    return timeIntervalEveryOneSecondsSubject.eraseToAnyPublisher()
  }

  func startTimer() {
    subscribeOneSecondsTimerIsValid()
    startMiliSecondsTimer()
  }

  func stopTimer() {
    miliSecondsTimer = nil
    secondsTimer = nil
    oneSecondsTimerIsValid = nil
    timeIntervalEveryOneSecondsSubject.send(completion: .finished)
  }
}

private extension TimerUseCase {
  private func startMiliSecondsTimer() {
    miliSecondsTimer = Timer.publish(every: 0.001, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] currentDate in
        guard let self else {
          return
        }
        let timeInterval = initDate.timeIntervalSince(currentDate)
        let currentMilisecondsString = String(format: "%.2f", timeInterval).suffix(2)
        if Int(currentMilisecondsString) == 0 {
          timeIntervalEveryOneSecondsSubject.send(lroundl(timeInterval))
          startOneSecondsTimer()
        }
      }
  }

  private func startOneSecondsTimer() {
    secondsTimer = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] currentDate in
        guard let timeInterval = self?.initDate.timeIntervalSince(currentDate) else {
          return
        }
        self?.timeIntervalEveryOneSecondsSubject.send(lroundl(timeInterval))
      }
  }

  private func subscribeOneSecondsTimerIsValid() {
    oneSecondsTimerIsValid = timeIntervalEveryOneSecondsSubject
      .sink { [weak self] _ in
        self?.miliSecondsTimer = nil
        self?.oneSecondsTimerIsValid = nil
      }
  }
}
