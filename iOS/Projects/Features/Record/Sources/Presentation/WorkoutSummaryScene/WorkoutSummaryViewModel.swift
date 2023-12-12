//
//  WorkoutSummaryViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/22/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - WorkoutSummaryViewModelInput

struct WorkoutSummaryViewModelInput {
  /// 화면이 로드될 때 이벤트가 한 번만 호출됩니다. 그 이후로는 바로 `finished`됩니다.
  let viewDidLoad: AnyPublisher<Void, Never>

  /// `처음으로` 버튼이 눌렸을 때 이벤트가 호출됩니다.
  let moveToFirstButtonPublisher: AnyPublisher<Void, Never>
}

typealias WorkoutSummaryViewModelOutput = AnyPublisher<WorkoutSummaryState, Never>

// MARK: - WorkoutSummaryState

enum WorkoutSummaryState {
  case idle
  case fetchSummary(WorkoutSummaryModel)
  case alert(Error)
}

// MARK: - WorkoutSummaryViewModelRepresentable

protocol WorkoutSummaryViewModelRepresentable {
  func transform(input: WorkoutSummaryViewModelInput) -> WorkoutSummaryViewModelOutput
}

// MARK: - WorkoutSummaryViewModel

final class WorkoutSummaryViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
  private weak var coordinating: WorkoutSessionCoordinating?
  private let workoutSummaryUseCase: WorkoutSummaryUseCaseRepresentable

  init(
    coordinating: WorkoutSessionCoordinating?,
    workoutSummaryUseCase: WorkoutSummaryUseCaseRepresentable
  ) {
    self.coordinating = coordinating
    self.workoutSummaryUseCase = workoutSummaryUseCase
  }
}

// MARK: WorkoutSummaryViewModelRepresentable

extension WorkoutSummaryViewModel: WorkoutSummaryViewModelRepresentable {
  public func transform(input: WorkoutSummaryViewModelInput) -> WorkoutSummaryViewModelOutput {
    // == Disposing of All Subscriptions ==
    subscriptions.removeAll()

    // == Input Output Binding ==
    input.moveToFirstButtonPublisher
      .sink { [weak self] in
        self?.coordinating?.setToMainRecord()
      }
      .store(in: &subscriptions)

    let fetchedWorkoutRecord = input.viewDidLoad
      .flatMap(workoutSummaryUseCase.workoutSummaryInformation)
      .map(WorkoutSummaryState.fetchSummary)
      .catch { return Just(.alert($0)) }
      .eraseToAnyPublisher()

    let initialState: WorkoutSummaryViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return Publishers.MergeMany([initialState, fetchedWorkoutRecord]).eraseToAnyPublisher()
  }
}
