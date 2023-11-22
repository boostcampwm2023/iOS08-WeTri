//
//  RecordListViewModel.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - RecordListViewModelInput

struct RecordListViewModelInput {
  let appear: AnyPublisher<Void, Never>
  let moveSelectScene: AnyPublisher<Void, Never>
}

typealias RecordListViewModelOutput = AnyPublisher<RecordListState, Error>

// MARK: - RecordListState

enum RecordListState {
  case idle
  case success([Record])
}

// MARK: - RecordListViewModel

final class RecordListViewModel {
  private var subscriptions: Set<AnyCancellable> = []

  private let recordUpdateUsecase: RecordUpdateUsecase

  init(recordUpdateUsecase: RecordUpdateUsecase) {
    self.recordUpdateUsecase = recordUpdateUsecase
  }
  // input 종류
  // 기록하러가기 버튼 탭 - 운동선택화면으로 이동한다.
}

// MARK: RecordListViewModelRepresentable

extension RecordListViewModel: RecordListViewModelRepresentable {
  func transform(input: RecordListViewModelInput) -> RecordListViewModelOutput {
    subscriptions.forEach {
      $0.cancel()
    }
    subscriptions.removeAll()

    let appear = input.appear
      .compactMap { [weak self] _ in
        return self?.recordUpdateUsecase.execute(calendarData:
          CalendarData(year: 2023, month: 11, date: 21)
        )
      }
      .flatMap { publisher in
        return publisher
      }
      .map { records -> RecordListState in
        .success(records)
      }
      .eraseToAnyPublisher()

    let initialState: RecordListViewModelOutput = Just(.idle)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()

    return Publishers
      .Merge(initialState, appear)
      .eraseToAnyPublisher()
  }
}

// MARK: - RecordListViewModelRepresentable

protocol RecordListViewModelRepresentable {
  func transform(input: RecordListViewModelInput) -> RecordListViewModelOutput
}
