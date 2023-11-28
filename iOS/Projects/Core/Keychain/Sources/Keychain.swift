//
//  Keychain.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 11/28/23.
//

import Foundation
import Security

public final class Keychain {
  
  /// 키체인에 키-data로 데이터를 저장합니다.
  public func save(key: String, data: Data) {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: data,
    ]

    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
  }

  /// 키체인에서 키를 통해 data 값을 얻어옵니다.
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
