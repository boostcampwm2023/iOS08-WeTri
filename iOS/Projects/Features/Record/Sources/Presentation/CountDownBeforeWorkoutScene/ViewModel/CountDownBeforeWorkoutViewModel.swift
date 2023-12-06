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
  let viewDidAppearPublisher: AnyPublisher<Void, Never>
  let didFinishTimerSubscription: AnyPublisher<Void, Never>
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

  weak var coordinator: WorkoutSessionCoordinating?
  var timerUseCase: CountDownBeforeWorkoutStartTimerUseCaseRepresentable
  // TODO: 차후 생성 시점에서 시작 시간을 넘길 예정
  private var subscriptions: Set<AnyCancellable> = []
  private var beforeWorkoutTimerSubject: CurrentValueSubject<String, Never> = .init("")
  init(coordinator: WorkoutSessionCoordinating, useCase: CountDownBeforeWorkoutStartTimerUseCaseRepresentable) {
    self.coordinator = coordinator
    timerUseCase = useCase
  }
}

// MARK: CountDownBeforeWorkoutViewModelRepresentable

extension CountDownBeforeWorkoutViewModel: CountDownBeforeWorkoutViewModelRepresentable {
  public func transform(input: CountDownBeforeWorkoutViewModelInput) -> CountDownBeforeWorkoutViewModelOutput {
    subscriptions.removeAll()

    input
      .viewDidAppearPublisher
      .sink { [weak self] _ in
        self?.timerUseCase.startTimer()
      }
      .store(in: &subscriptions)

    input
      .didFinishTimerSubscription
      .sink { [weak self] _ in
        self?.coordinator?.pushWorkoutSession()
      }
      .store(in: &subscriptions)

    let timerMessagePublisher = timerUseCase
      .beforeWorkoutTimerTextPublisher()
      .map { message -> CountDownBeforeWorkoutState in
        return .updateMessage(message: message)
      }
      .eraseToAnyPublisher()

    let initialState: CountDownBeforeWorkoutViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState.merge(with: timerMessagePublisher).eraseToAnyPublisher()
  }
}

// MARK: CountDownBeforeWorkoutViewModel.Consts

private extension CountDownBeforeWorkoutViewModel {
  enum Consts {
    static let timerInitValue = 1
    static let timerEndValue = 3
  }
}
