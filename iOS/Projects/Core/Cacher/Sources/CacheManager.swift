//
//  CacheManager.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 12/3/23.
//

import Foundation

public final class CacheManager {
  public static let shared = CacheManager()

  private let cacher = Cacher(fileManager: FileManager.default)

  private init() {}

  public func fetch(cacheKey: String) throws -> Data? {
    try cacher.fetch(cacheKey: cacheKey)
  }

  public func set(cacheKey: String, data: Data) throws {
    try cacher.set(data: data, cacheKey: cacheKey)
  }
}
