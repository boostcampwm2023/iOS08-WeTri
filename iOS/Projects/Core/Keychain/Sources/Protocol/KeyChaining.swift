//
//  KeyChaining.swift
//  Keychain
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

public protocol Keychaining {
  /// 키체인에 키-data로 데이터를 저장합니다.
  @discardableResult
  func save(key: String, data: Data) -> OSStatus

  /// 키체인에서 키를 통해 data 값을 얻어옵니다.
  func load(key: String) -> Data?

  /// 키체인에서 해당하는 키를 삭제합니다.
  @discardableResult
  func delete(key: String) -> OSStatus
}
