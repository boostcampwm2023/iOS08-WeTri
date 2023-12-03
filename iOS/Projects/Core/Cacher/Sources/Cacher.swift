//
//  Cacher.swift
//  Cacher
//
//  Created by 안종표 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - CacheError

enum CacheError: Error {
  case invalidFileURL
  case invalidData
}

// MARK: - Cacher

final class Cacher {
  private let cache = NSCache<NSString, NSData>()
  private let fileManager: FileManager

  init(fileManager: FileManager) {
    self.fileManager = fileManager
  }

  func fetch(cacheKey: String) throws -> Data? {
    if let memoryData = fetchMemoryData(cacheKey: cacheKey) {
      return memoryData
    }

    if let diskData = try fetchDiskData(cacheKey: cacheKey) {
      return diskData
    }
    throw CacheError.invalidData
  }

  func set(data: Data, cacheKey: String) throws {
    setMemory(data: data, cacheKey: cacheKey)
    try setDisk(data: data, cacheKey: cacheKey)
  }

  func fetchMemoryData(cacheKey: String) -> Data? {
    return cache.object(forKey: cacheKey as NSString) as? Data
  }

  func fetchDiskData(cacheKey: String) throws -> Data? {
    guard let url = generateFileURL(cacheKey: cacheKey) else {
      throw CacheError.invalidFileURL
    }
    let data = try Data(contentsOf: url)
    return data
  }

  func setMemory(data: Data, cacheKey: String) {
    cache.setObject(data as NSData, forKey: cacheKey as NSString)
  }

  func setDisk(data: Data, cacheKey: String) throws {
    guard let url = generateFileURL(cacheKey: cacheKey) else {
      throw CacheError.invalidFileURL
    }
    let path = url.path()
    try fileManager.createDirectory(
      atPath: path,
      withIntermediateDirectories: true
    )
    fileManager.createFile(atPath: path, contents: data)
  }

  private func generateFileURL(cacheKey: String) -> URL? {
    return fileManager.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    )
    .first?
    .appending(path: cacheKey)
  }
}
