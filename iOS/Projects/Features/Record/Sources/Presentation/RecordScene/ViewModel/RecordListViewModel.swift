//
//  RecordListViewModel.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Coordinator
import Foundation
import Log

// MARK: - RecordListViewModelInput

struct RecordListViewModelInput {
  let appear: AnyPublisher<Void, Never>
  let goRecordButtonDidTapped: AnyPublisher<Void, Never>
  let selectedDate: AnyPublisher<IndexPath, Never>
}

typealias RecordListViewModelOutput = AnyPublisher<RecordListState, Never>

// MARK: - RecordListState

enum RecordListState {
  case idle
  case sucessRecords([Record])
  case sucessDateInfo(DateInfo)
  case customError(Error)
}

// MARK: - RecordListViewModel

final class RecordListViewModel {
  private var subscriptions: Set<AnyCancellable> = []

  private let coordinator: RecordFeatureCoordinator
  private let recordUpdateUsecase: RecordUpdateUseCaseRepresentable
  private let dateProvideUsecase: DateProvideUseCaseRepresentable

  init(
    recordUpdateUsecase: RecordUpdateUseCaseRepresentable,
    dateProvideUsecase: DateProvideUseCaseRepresentable,
    coordinator: RecordFeatureCoordinator
  ) {
    self.recordUpdateUsecase = recordUpdateUsecase
    self.dateProvideUsecase = dateProvideUsecase
    self.coordinator = coordinator
  }
}

// MARK: RecordListViewModelRepresentable

extension RecordListViewModel: RecordListViewModelRepresentable {
  func transform(input: RecordListViewModelInput) -> RecordListViewModelOutput {
    for subscription in subscriptions {
      subscription.cancel()
    }
    subscriptions.removeAll()

    let appearRecords = input.appear
      .flatMap { [weak self] _ -> AnyPublisher<RecordListState, Never> in
        guard let self else {
          return Just(.customError(RecordListViewModelError.viewModelDeinitialized))
            .eraseToAnyPublisher()
        }
        return recordUpdateUsecase.execute(date: Date.now, isToday: true)
          .map { records -> RecordListState in
            .sucessRecords(records)
          }
          .catch { _ -> AnyPublisher<RecordListState, Never> in
            return Just(.customError(RecordListViewModelError.dateNotFound))
              .eraseToAnyPublisher()
          }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    let appearDate = input.appear
      .flatMap { [weak self] _ -> AnyPublisher<RecordListState, Never> in
        guard let self else {
          return Just(.customError(RecordListViewModelError.viewModelDeinitialized))
            .eraseToAnyPublisher()
        }
        let dateInfo = dateProvideUsecase.transform(date: Date.now)
        return Just(.sucessDateInfo(dateInfo))
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    let selectedRecords = input.selectedDate
      .flatMap { [weak self] indexPath -> AnyPublisher<RecordListState, Never> in
        guard let self else {
          return Just(.customError(RecordListViewModelError.viewModelDeinitialized))
            .eraseToAnyPublisher()
        }
        guard
          let dateInfo = dateProvideUsecase.selectedDateInfo(index: indexPath.item),
          let date = dateProvideUsecase.transform(dateInfo: dateInfo)
        else {
          return Just(.customError(RecordListViewModelError.dateNotFound))
            .eraseToAnyPublisher()
        }
        let isToday = dateProvideUsecase.isToday(date: date)
        if !isToday {
          return recordUpdateUsecase.executeCached(date: date)
            .map { records -> RecordListState in
              return .sucessRecords(records)
            }
            .catch { [weak self] error -> AnyPublisher<RecordListState, Never> in
              if let repositoryError = error as? WorkoutRecordsRepositoryError {
                switch repositoryError {
                case .invalidCachedData:
                  guard let publisher = self?.recordUpdateUsecase.execute(date: date, isToday: isToday)
                  else {
                    return Just(.sucessRecords([]))
                      .eraseToAnyPublisher()
                  }
                  return publisher
                    .map { records -> RecordListState in
                      return .sucessRecords(records)
                    }
                    .catch { _ in
                      return Just(.sucessRecords([]))
                        .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
                default:
                  break
                }
              }
              return Just(.sucessRecords([]))
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        } else {
          return recordUpdateUsecase.execute(date: date, isToday: isToday)
            .map { records -> RecordListState in
              return .sucessRecords(records)
            }
            .catch { _ in
              return Just(.sucessRecords([]))
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        }
      }

    let selectedDate = input.selectedDate
      .flatMap { [weak self] indexPath -> AnyPublisher<RecordListState, Never> in
        guard let self else {
          return Just(.customError(RecordListViewModelError.viewModelDeinitialized))
            .eraseToAnyPublisher()
        }
        guard let dateInfo = dateProvideUsecase.selectedDateInfo(index: indexPath.item) else {
          return Just(.customError(RecordListViewModelError.dateNotFound))
            .eraseToAnyPublisher()
        }
        return Just(.sucessDateInfo(dateInfo))
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()

    input.goRecordButtonDidTapped
      .sink { [weak self] _ in
        self?.coordinator.showSettingFlow()
      }
      .store(in: &subscriptions)

    let initialState: RecordListViewModelOutput = Just(.idle)
      .eraseToAnyPublisher()

    return Publishers
      .Merge5(initialState, appearRecords, appearDate, selectedRecords, selectedDate)
      .eraseToAnyPublisher()
  }
}

// MARK: - RecordListViewModelRepresentable

protocol RecordListViewModelRepresentable {
  func transform(input: RecordListViewModelInput) -> RecordListViewModelOutput
}

// MARK: - RecordListViewModelError

private enum RecordListViewModelError: Error {
  case viewModelDeinitialized
  case dateNotFound
  case dateInfoNotTransformed
  case recordUpdateFail
}

// MARK: LocalizedError

extension RecordListViewModelError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .viewModelDeinitialized:
      return "RecordListViewModel이 메모리에서 해제되었습니다."
    case .dateNotFound:
      return "DateProvideUseCase에서 index에 해당하는 날짜를 찾지 못했습니다."
    case .dateInfoNotTransformed:
      return "dateInfo를 Date로 변환하지 못했습니다."
    case .recordUpdateFail:
      return "record 정보를 불러오는데 실패하였습니다."
    }
  }
}
