//
//  CountDownBeforeWorkoutViewModel.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/27/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - CountDownBeforeWorkoutViewModelInput

public struct CountDownBeforeWorkoutViewModelInput {}

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

  weak var coordinator: WorkoutSettingCoordinator?
  private var subscriptions: Set<AnyCancellable> = []
  private var timerSubject: PassthroughSubject<String, Never> = .init()
  init(coordinator: WorkoutSettingCoordinator) {
    self.coordinator = coordinator
  }
}

// MARK: CountDownBeforeWorkoutViewModelRepresentable

extension CountDownBeforeWorkoutViewModel: CountDownBeforeWorkoutViewModelRepresentable {
  public func transform(input _: CountDownBeforeWorkoutViewModelInput) -> CountDownBeforeWorkoutViewModelOutput {
    subscriptions.removeAll()

    reserveMessage()
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
        self?.timerSubject.send(text)
      })
      .store(in: &subscriptions)
  }

  func reserveMessage() {
    if Consts.timerInitValue >= Consts.timerEndValue { return }
    (Consts.timerInitValue ... Consts.timerEndValue)
      .reversed()
      .forEach { sendSubjectMessage(after: messageWatingTime(at: $0), message: $0.description) }
    sendSubjectMessage(after: messageWatingTime(at: 0), message: "Over", finish: true)
  }

  func messageWatingTime(at time: Int) -> Double {
    return Double(Consts.timerEndValue - time)
  }

  func sendSubjectMessage(after: Double, message: String, finish: Bool = false) {
    DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
      if finish {
        self?.timerSubject.send(completion: .finished)
      } else {
        self?.timerSubject.send(message)
      }
    }
  }

  enum Consts {
    static let timerInitValue = 1
    static let timerEndValue = 3
  }
}
