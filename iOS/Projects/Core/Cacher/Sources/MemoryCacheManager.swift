//
//  MemoryCacheManager.swift
//  Cacher
//
//  Created by MaraMincho on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

/// 인메모리 캐시를 활용하여 정보를 저장하고 fetch합니다.
public final class MemoryCacheManager {
  public static let shared = MemoryCacheManager()

  private let cacher = Cacher(fileManager: FileManager.default)

  private init() {}

  /// 인메모리 캐시를 활용하여 정보를 fetch합니다.
  public func fetch(cacheKey key: String) -> Data? {
    return cacher.fetchMemoryData(cacheKey: key)
  }

  /// 인메모리 캐시를 활용하여 정보를 저장합니다.
  public func set(cacheKey key: String, data: Data) {
    cacher.setMemory(data: data, cacheKey: key)
  }
}
