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
  let appearSection: AnyPublisher<Int, Never>
  let calendarDateDidTapped: AnyPublisher<IndexPath, Never>
  let calendarCellReuse: AnyPublisher<Void, Never>
}

typealias RecordCalendarViewModelOutput = AnyPublisher<RecordCalendarState, Never>

// MARK: - RecordCalendarState

enum RecordCalendarState {
  case date([DateInfo])
  case selectedIndexPath(IndexPath)
  case customError(Error)
}

// MARK: - RecordCalendarViewModel

final class RecordCalendarViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateProvideUseCase: DateProvideUseCaseRepresentable

  private(set) var currentSelectedIndexPath: IndexPath?

  init(dateProvideUseCase: DateProvideUseCaseRepresentable) {
    self.dateProvideUseCase = dateProvideUseCase
  }
}

// MARK: RecordCalendarViewModelRepresentable

extension RecordCalendarViewModel: RecordCalendarViewModelRepresentable {
  func transform(input: RecordCalendarViewModelInput) -> RecordCalendarViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let appearTotalDateInfo = input.appear
      .flatMap { [weak self] _ -> AnyPublisher<RecordCalendarState, Never> in
        guard let self else {
          return Just(.customError(BindingError.viewModelDeinitialized))
            .eraseToAnyPublisher()
        }
        let allDates = dateProvideUseCase.fetchAllDatesThisMonth()
        return Just(.date(allDates))
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    let appearTodayIndex = input.appearSection
      .flatMap { [weak self] sectionCount -> AnyPublisher<RecordCalendarState, Never> in
        guard let self else {
          return Just(.customError(BindingError.viewModelDeinitialized))
            .eraseToAnyPublisher()
        }
        let todayIndex = dateProvideUseCase.todayIndex(sectionCount: sectionCount)
        currentSelectedIndexPath = todayIndex
        return Just(.selectedIndexPath(todayIndex))
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    input.calendarDateDidTapped
      .sink { [weak self] indexPath in
        self?.currentSelectedIndexPath = indexPath
      }
      .store(in: &subscriptions)

    let reuse = input.calendarCellReuse
      .flatMap { [weak self] _ -> AnyPublisher<RecordCalendarState, Never> in
        guard let currentSelectedIndexPath = self?.currentSelectedIndexPath else {
          return Just(.customError(BindingError.invalidCurrentSelectedIndexPath))
            .eraseToAnyPublisher()
        }
        return Just(.selectedIndexPath(currentSelectedIndexPath))
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    return Publishers
      .Merge3(appearTotalDateInfo, reuse, appearTodayIndex)
      .eraseToAnyPublisher()
  }
}

// MARK: - RecordCalendarViewModelRepresentable

protocol RecordCalendarViewModelRepresentable {
  var currentSelectedIndexPath: IndexPath? { get }

  func transform(input: RecordCalendarViewModelInput) -> RecordCalendarViewModelOutput
}

// MARK: - BindingError

private enum BindingError: Error {
  case viewModelDeinitialized
  case invalidCurrentSelectedIndexPath
}

// MARK: LocalizedError

extension BindingError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .viewModelDeinitialized:
      return "RecordCalendarViewModel이 메모리에서 해제되었습니다."
    case .invalidCurrentSelectedIndexPath:
      return "currentSelectedIndexPath이 유효하지 않습니다."
    }
  }
}
