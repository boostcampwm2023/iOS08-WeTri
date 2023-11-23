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
}

typealias RecordCalendarViewModelOutput = AnyPublisher<RecordCalendarState, Error>

// MARK: - RecordCalendarState

enum RecordCalendarState {
  case date([DateInfo])
}

// MARK: - RecordCalendarViewModel

final class RecordCalendarViewModel {}

// MARK: RecordCalendarViewModelRepresentable

extension RecordCalendarViewModel: RecordCalendarViewModelRepresentable {
  func transform(input: RecordCalendarViewModelInput) -> RecordCalendarViewModelOutput {
    let appear = input.appear
      .flatMap { _ -> AnyPublisher<[DateInfo], Error> in
        return Just([DateInfo(year: "", month: "", date: "", dayOfWeek: "")])
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
