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
}
