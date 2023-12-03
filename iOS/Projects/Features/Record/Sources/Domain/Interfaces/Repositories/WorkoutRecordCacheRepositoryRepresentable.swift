//
//  WorkoutRecordCacheRepositoryRepresentable.swift
//  RecordFeature
//
//  Created by 안종표 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

protocol WorkoutRecordCacheRepositoryRepresentable {
  func fetch(cacheKey: String) throws -> Data?
  func set(data: Data, cacheKey: String) throws
  func fetchMemoryData(cacheKey: String) -> Data?
  func fetchDiskData(cacheKey: String) throws -> Data?
  func setMemory(data: Data, cacheKey: String)
  func setDisk(data: Data, cacheKey: String) throws
  func generateFileURL(cacheKey: String) -> URL?
}
