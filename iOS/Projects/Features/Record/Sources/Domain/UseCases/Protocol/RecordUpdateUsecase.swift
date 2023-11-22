//
//  RecordUpdateUsecase.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol RecordUpdateUsecase {
  /// Usecase에서 Repository로 넘기기전에 String형태의 날짜로 바꿔서 보내주기.
  /// yyyy-mm-dd 형식
  /// 따로 Usecase에서 처리할 비즈니스로직 없으면 Repository에서 받아온 데이터 그대로 넘기기.
  func execute(calendarData: CalendarData) -> AnyPublisher<[Record], Never>
}
