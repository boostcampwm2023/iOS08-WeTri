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
  /// memory와 disk에서 데이터를 가져옵니다.
  /// memory캐시를 진행하고 메모리에 데이터가 없으면 디스크캐시로 넘어갑니다. 그마저 없다면 Error를 방출합니다.
  /// Error는 나중에 API호출로 처리됩니다.
  func fetch(cacheKey: String) throws -> Data? {
    if let memoryData = fetchMemoryData(cacheKey: cacheKey) {
      return memoryData
    }

    if let diskData = try fetchDiskData(cacheKey: cacheKey) {
      return diskData
    }
    throw CacheError.invalidData
  }

  /// memory와 disk에 캐시할 데이터를 저장합니다.
  func set(data: Data, cacheKey: String) throws {
    setMemory(data: data, cacheKey: cacheKey)
    try setDisk(data: data, cacheKey: cacheKey)
  }
  
  /// memory데이터를 불러옵니다.
  func fetchMemoryData(cacheKey: String) -> Data? {
    return cache.object(forKey: cacheKey as NSString) as? Data
  }

  /// disk데이터를 불러옵니다.
  func fetchDiskData(cacheKey: String) throws -> Data? {
    guard let directoryURL = generateFileURL(cacheKey: cacheKey) else {
      throw CacheError.invalidFileURL
    }
    let fileURL = directoryURL.appending(path: cacheKey)
    let data = try Data(contentsOf: fileURL)
    return data
  }

  /// memory에 데이터를 저장합니다.
  func setMemory(data: Data, cacheKey: String) {
    cache.setObject(data as NSData, forKey: cacheKey as NSString)
  }

  /// disk에 데이터를 저장합니다.
  func setDisk(data: Data, cacheKey: String) throws {
    guard let url = generateFileURL(cacheKey: cacheKey) else {
      throw CacheError.invalidFileURL
    }
    let path = url.path()
    try fileManager.createDirectory(
      atPath: path,
      withIntermediateDirectories: true
    )
    let appendedPath = url.appending(path: cacheKey).path()
    fileManager.createFile(atPath: appendedPath, contents: data)
  }

  /// cache 디렉토리가 존재하는 URL을 구합니다.
  private func generateFileURL(cacheKey: String) -> URL? {
    return fileManager.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    )
    .first?
    .appending(path: cacheKey)
  }
}
