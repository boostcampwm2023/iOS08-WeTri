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
  let workoutInitTime: Date = .now + 8
  private var subscriptions: Set<AnyCancellable> = []
  private var timerSubject: CurrentValueSubject<String, Never> = .init("")
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

    let timerMessagePublisher = timerSubject
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
    timerSubject
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
        self?.timerSubject.send(text)
      })
      .store(in: &subscriptions)
  }

  func timerValueValueBeforeWorkoutStart() -> String {
    let message = Int(workoutInitTime.timeIntervalSince(.now)).description
    return message
  }

  func setTimer() {
    timerSubject.send(timerValueValueBeforeWorkoutStart())
    Timer.publish(every: 1, on: RunLoop.main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self else { return }
        let message = timerValueValueBeforeWorkoutStart()
        message != "0" ? timerSubject.send(message) : timerSubject.send(completion: .finished)
      }
      .store(in: &subscriptions)
  }

  func sendSubjectMessage() {}

  enum Consts {
    static let timerInitValue = 1
    static let timerEndValue = 3
  }
}
