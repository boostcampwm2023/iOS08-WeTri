//
//  KeychainRepository.swift
//  LoginFeature
//
//  Created by 안종표 on 11/29/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation
import Keychain

// MARK: - KeychainRepositoryError

enum KeychainRepositoryError: Error {
  case invalidKey
}

// MARK: - KeychainRepository

final class KeychainRepository: KeychainRepositoryRepresentable {
  private let keychain: Keychaining

  init(keychain: Keychaining) {
    self.keychain = keychain
  }

  func save(key: String, value: String) {
    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(value)
      keychain.save(key: key, data: data)
    } catch {}
  }

  func load(key: String) -> AnyPublisher<Data, Error> {
    return Future<Data, Error> { [weak self] promise in
      guard let data = self?.keychain.load(key: key) else {
        return promise(.failure(KeychainRepositoryError.invalidKey))
      }
      return promise(.success(data))
    }
    .eraseToAnyPublisher()
  }

  func delete(key: String) -> AnyPublisher<Void, Error> {
    return Future<Void, Error> { [weak self] promise in
      let status = self?.keychain.delete(key: key)
      guard status != errSecItemNotFound else {
        return promise(.failure(KeychainRepositoryError.invalidKey))
      }
      return promise(.success(()))
    }
    .eraseToAnyPublisher()
  }
}
