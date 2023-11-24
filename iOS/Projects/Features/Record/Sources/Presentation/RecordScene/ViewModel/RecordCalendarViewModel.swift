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
import OSLog

// MARK: - RecordCalendarViewModelInput

struct RecordCalendarViewModelInput {
  let appear: AnyPublisher<Void, Never>
  let calendarDateDidTapped: AnyPublisher<IndexPath, Never>
  let calendarCellReuse: AnyPublisher<Void, Never>
}

typealias RecordCalendarViewModelOutput = AnyPublisher<RecordCalendarState, Error>

// MARK: - RecordCalendarState

enum RecordCalendarState {
  case date([DateInfo])
  case selectedIndexPath(IndexPath)
}

// MARK: - RecordCalendarViewModel

final class RecordCalendarViewModel {
  private var subscriptions: Set<AnyCancellable> = []
  private let dateProvideUseCase: DateProvideUseCaseRepresentable

  // TODO: 초기값으로 오늘날짜 설정
  private var currentSelectedIndexPath: IndexPath = .init(item: 0, section: 0)

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

    input.calendarDateDidTapped
      .sink { [weak self] indexPath in
        self?.currentSelectedIndexPath = indexPath
        Logger().debug("currentSelectedIndexPath: \(indexPath.item)")
      }
      .store(in: &subscriptions)

    let reuse = input.calendarCellReuse
      .flatMap { [weak self] _ -> AnyPublisher<IndexPath, Error> in
        guard let currentSelectedIndexPath = self?.currentSelectedIndexPath else {
          return Fail(error: BindingError.invalidCurrentSelectedIndexPath).eraseToAnyPublisher()
        }
        return Just(currentSelectedIndexPath)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .map { indexPath -> RecordCalendarState in
        .selectedIndexPath(indexPath)
      }
      .eraseToAnyPublisher()

    return Publishers
      .Merge(appear, reuse)
      .eraseToAnyPublisher()
  }
}

// MARK: - RecordCalendarViewModelRepresentable

protocol RecordCalendarViewModelRepresentable {
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
