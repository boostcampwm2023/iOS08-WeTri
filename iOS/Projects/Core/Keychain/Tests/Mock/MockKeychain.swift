//
//  MockKeychain.swift
//  Keychain
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

final class MockKeychain: Keychaining {
  var keyChain: [String: Data] = [:]

  @discardableResult
  func save(key: String, data: Data) -> OSStatus {
    keyChain[key] = data
    return noErr
  }

  func load(key: String) -> Data? {
    guard let data = keyChain[key] else {
      return nil
    }
    return data
  }

  @discardableResult
  func delete(key: String) -> OSStatus {
    guard keyChain[key] != nil else {
      return errSecItemNotFound
    }
    keyChain.removeValue(forKey: key)
    return noErr
  }
}
