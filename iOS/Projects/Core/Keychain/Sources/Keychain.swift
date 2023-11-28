//
//  Keychain.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 11/28/23.
//

import Foundation
import Security

public final class Keychain {
  ///
  public func save(key: String, data: Data) {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: data,
    ]

    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
  }

  ///
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
}
