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

// MARK: - RecordListViewModelInput

struct RecordListViewModelInput {
  let appear: AnyPublisher<Void, Never>
  let goRecordButtonDidTapped: AnyPublisher<Void, Never>
  let selectedDate: AnyPublisher<IndexPath, Never>
}

typealias RecordListViewModelOutput = AnyPublisher<RecordListState, Error>

// MARK: - RecordListState

enum RecordListState {
  case idle
  case sucessRecords([Record])
  case sucessDateInfo(DateInfo)
  case moveScene
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
    subscriptions.forEach {
      $0.cancel()
    }
    subscriptions.removeAll()

    let appearRecords = input.appear
      .flatMap { [weak self] _ -> AnyPublisher<[Record], Error> in
        guard let self else {
          return Fail(error: BindingError.viewModelDeinitialized).eraseToAnyPublisher()
        }
        let todayDate = dateProvideUsecase.today()
        return recordUpdateUsecase.execute(date: todayDate)
      }
      .map { records -> RecordListState in
        .sucessRecords(records)
      }
      .eraseToAnyPublisher()

    let appearDate = input.appear
      .flatMap { [weak self] _ -> AnyPublisher<DateInfo, Error> in
        guard let self else {
          return Fail(error: BindingError.viewModelDeinitialized).eraseToAnyPublisher()
        }
        let todayDate = dateProvideUsecase.today()
        let dateInfo = dateProvideUsecase.transform(date: todayDate)
        return Just(dateInfo)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .map { dateInfo -> RecordListState in
        .sucessDateInfo(dateInfo)
      }
      .eraseToAnyPublisher()

    let selectedRecords = input.selectedDate
      .flatMap { [weak self] indexPath -> AnyPublisher<[Record], Error> in
        guard let self else {
          return Fail(error: BindingError.viewModelDeinitialized).eraseToAnyPublisher()
        }
        guard let dateInfo = dateProvideUsecase.selectedDateInfo(index: indexPath.item) else {
          return Fail(error: BindingError.dateNotFound).eraseToAnyPublisher()
        }
        guard let date = dateProvideUsecase.transform(dateInfo: dateInfo) else {
          return Fail(error: BindingError.dateNotFound).eraseToAnyPublisher()
        }
        return recordUpdateUsecase.execute(date: date)
      }
      .map { records -> RecordListState in
        .sucessRecords(records)
      }
      .eraseToAnyPublisher()

    let selectedDate = input.selectedDate
      .flatMap { [weak self] indexPath -> AnyPublisher<DateInfo, Error> in
        guard let self else {
          return Fail(error: BindingError.viewModelDeinitialized).eraseToAnyPublisher()
        }
        guard let dateInfo = dateProvideUsecase.selectedDateInfo(index: indexPath.item) else {
          return Fail(error: BindingError.dateNotFound).eraseToAnyPublisher()
        }
        return Just(dateInfo)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .map { dateInfo -> RecordListState in
        .sucessDateInfo(dateInfo)
      }
      .eraseToAnyPublisher()

    input.goRecordButtonDidTapped
      .sink { [weak self] _ in
        self?.coordinator.showSettingFlow()
      }
      .store(in: &subscriptions)

    let initialState: RecordListViewModelOutput = Just(.idle)
      .setFailureType(to: Error.self)
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

// MARK: - BindingError

private enum BindingError: Error {
  case viewModelDeinitialized
  case dateNotFound
  case dateInfoNotTransformed
}

// MARK: LocalizedError

extension BindingError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .viewModelDeinitialized:
      return "RecordListViewModel이 메모리에서 해제되었습니다."
    case .dateNotFound:
      return "DateProvideUseCase에서 index에 해당하는 날짜를 찾지 못했습니다."
    case .dateInfoNotTransformed:
      return "dateInfo를 Date로 변환하지 못했습니다."
    }
  }
}
