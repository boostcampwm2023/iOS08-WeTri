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
  var timerPeriod: Double { get }
  func intervalCurrentAndInitEverySecondsPublisher() -> AnyPublisher<Int, Never>
  func startTimer()
  func stopTimer()
}

// MARK: - TimerUseCase

class TimerUseCase: TimerUseCaseRepresentable {
  let initDate: Date
  let timerPeriod: Double
  private var periodTimer: AnyCancellable? = nil
  private var miliSecondsTimer: AnyCancellable? = nil
  private var timeIntervalAtEachPeriodPublisher: PassthroughSubject<Int, Never> = .init()

  init(initDate: Date, timerPeriod: Double = 1) {
    self.initDate = initDate
    self.timerPeriod = timerPeriod
  }

  func intervalCurrentAndInitEverySecondsPublisher() -> AnyPublisher<Int, Never> {
    return timeIntervalAtEachPeriodPublisher.eraseToAnyPublisher()
  }

  func startTimer() {
    startMiliSecondsTimer()
  }

  func stopTimer() {
    miliSecondsTimer = nil
    periodTimer = nil
    timeIntervalAtEachPeriodPublisher.send(completion: .finished)
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
        let currentMillisecondsString = String(format: "%.2f", timeInterval)
        if Int(currentMillisecondsString.suffix(2)) == 0 {
          if timeInterval.rounded(.toNearestOrAwayFromZero) >= timerPeriod {
            timeIntervalAtEachPeriodPublisher.send(Int(timeInterval.rounded(.toNearestOrAwayFromZero)))
          }
          startPeriodTimer()
          stopMillisecondsTimer()
        }
      }
  }

  private func startPeriodTimer() {
    periodTimer = Timer.publish(every: timerPeriod, on: RunLoop.main, in: .common)
      .autoconnect()
      .sink { [weak self] currentDate in
        guard let self else {
          return
        }
        let timeInterval = initDate.timeIntervalSince(currentDate)
        timeIntervalAtEachPeriodPublisher.send(Int(timeInterval.rounded(.toNearestOrAwayFromZero)))
      }
  }

  private func stopMillisecondsTimer() {
    miliSecondsTimer = nil
  }
}
