//
//  WorkoutSessionViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/16/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine

// MARK: - WorkoutSessionViewModelInput

struct WorkoutSessionViewModelInput {}

typealias WorkoutSessionViewModelOutput = AnyPublisher<WorkoutSessionState, Never>

// MARK: - WorkoutSessionState

enum WorkoutSessionState {
  case idle
  case fetchMyHealthForm(WorkoutHealthForm)
  case fetchParticipantsIncludedMySelf(WorkoutRealTimeModel)
  case alert(Error)
}

// MARK: - WorkoutSessionViewModelRepresentable

protocol WorkoutSessionViewModelRepresentable {
  func transform(input: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput
}

// MARK: - WorkoutSessionViewModel

final class WorkoutSessionViewModel {
  // MARK: Properties

  private let useCase: WorkoutSessionUseCaseRepresentable

  private var subscriptions: Set<AnyCancellable> = []

  // MARK: Initializations

  init(useCase: WorkoutSessionUseCaseRepresentable) {
    self.useCase = useCase
  }
}

// MARK: WorkoutSessionViewModelRepresentable

extension WorkoutSessionViewModel: WorkoutSessionViewModelRepresentable {
  func transform(input _: WorkoutSessionViewModelInput) -> WorkoutSessionViewModelOutput {
    subscriptions.removeAll()

    let myHealth = useCase.myHealthFormPublisher
      .map(WorkoutSessionState.fetchMyHealthForm)
      .catch { Just(.alert($0)) }

    let participants = useCase.participantsStatusPublisher
      .map(WorkoutSessionState.fetchParticipantsIncludedMySelf)
      .catch { Just(.alert($0)) }

    return Just(.idle).merge(with: myHealth, participants).eraseToAnyPublisher()
  }
}
