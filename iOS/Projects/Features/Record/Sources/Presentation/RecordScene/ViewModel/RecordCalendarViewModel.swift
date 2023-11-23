//
//  RecordCalendarViewModel.swift
//  RecordFeature
//
//  Created by 안종표 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Coordinator
import Foundation

// MARK: - RecordCalendarViewModelInput

struct RecordCalendarViewModelInput {
  let appear: AnyPublisher<Void, Never>
  let calendarDateDidTapped: AnyPublisher<IndexPath, Never>
}

typealias RecordCalendarViewModelOutput = AnyPublisher<RecordCalendarState, Error>

// MARK: - RecordCalendarState

enum RecordCalendarState {
  case date([DateInfo])
}

// MARK: - RecordCalendarViewModel

final class RecordCalendarViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateProvideUseCase: DateProvideUseCaseRepresentable

  init(dateProvideUseCase: DateProvideUseCaseRepresentable) {
    self.dateProvideUseCase = dateProvideUseCase
  }
}

// MARK: RecordCalendarViewModelRepresentable

extension RecordCalendarViewModel: RecordCalendarViewModelRepresentable {
  func transform(input: RecordCalendarViewModelInput) -> RecordCalendarViewModelOutput {
    subscriptions.forEach {
      $0.cancel()
    }
    subscriptions.removeAll()

    let appear = input.appear
      .flatMap { [weak self] _ -> AnyPublisher<[DateInfo], Error> in
        guard let self else {
          return Fail(error: BindingError.viewModelDeinitialized)
            .eraseToAnyPublisher()
        }
        let allDates = dateProvideUseCase.fetchAllDatesThisMonth()
        return Just(allDates)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .map { dateInfos -> RecordCalendarState in
        .date(dateInfos)
      }
      .eraseToAnyPublisher()

    return appear
  }
}

// MARK: - RecordCalendarViewModelRepresentable

protocol RecordCalendarViewModelRepresentable {
  func transform(input: RecordCalendarViewModelInput) -> RecordCalendarViewModelOutput
}

// MARK: - BindingError

private enum BindingError: Error {
  case viewModelDeinitialized
}

// MARK: LocalizedError

extension BindingError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .viewModelDeinitialized:
      return "RecordCalendarViewModel이 메모리에서 해제되었습니다."
    }
  }
}
