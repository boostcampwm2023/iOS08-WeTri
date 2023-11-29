//
//  KeychainRepositoryRepresentable.swift
//  LoginFeature
//
//  Created by 안종표 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol KeychainRepositoryRepresentable {
  /// 키체인에 키-data로 데이터를 저장합니다.
  func save(key: String, value: String)

  /// 키체인에서 키를 통해 data 값을 얻어옵니다.
  func load(key: String) -> AnyPublisher<Data, Error>

  /// 키체인에서 해당하는 키를 삭제합니다.
  func delete(key: String) -> AnyPublisher<Void, Error>
}
