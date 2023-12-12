//
//  Keychain.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 11/28/23.
//

import Foundation
import Security

public final class Keychain: Keychaining {
  public static let shared = Keychain()

  private init() {}

  @discardableResult
  public func save(key: String, data: Data) -> OSStatus {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: data,
    ]

    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil)
  }

  public func load(key: String) -> Data? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecReturnData: kCFBooleanTrue!,
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    guard status == noErr else {
      return nil
    }

    return item as? Data
  }

  @discardableResult
  public func delete(key: String) -> OSStatus {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
    ]

    return SecItemDelete(query as CFDictionary)
  }
}
