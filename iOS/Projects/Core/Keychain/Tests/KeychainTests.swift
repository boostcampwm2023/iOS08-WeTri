//
//  KeychainTests.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 11/28/23.
//

@testable import Keychain
import XCTest

final class KeychainTests: XCTestCase {
  var sut: Keychaining!
  var key: String!

  override func setUp() {
    sut = MockKeychain()
    key = "TestKey"
  }

  func test_keychain에_데이터저장_성공() throws {
    // Arrage
    let password = "PaSSwOrd!@#$%QWER"
    let data = try JSONEncoder().encode(password)
    // Act
    let osstatus = sut.save(key: key, data: data)

    // Assert
    XCTAssertEqual(osstatus, noErr)
  }

  func test_keychain에_데이터저장후에_로드성공() throws {
    // Arrange
    let password = "PaSSwOrd!@#$%QWER"
    let data = try JSONEncoder().encode(password)
    // Act
    sut.save(key: key, data: data)
    let loadedData = sut.load(key: key)!
    let decodedData = try JSONDecoder().decode(String.self, from: loadedData)

    // Assert
    XCTAssertEqual(password, decodedData)
  }

  func test_keychain에_데이터저장후에_없는_키값으로인한_로드_실패() throws {
    // Arrange
    let password = "PaSSwOrd!@#$%QWER"
    let data = try JSONEncoder().encode(password)
    let differentKey = "what?"

    // Act
    sut.save(key: differentKey, data: data)
    let loadedData = sut.load(key: key)

    // Assert
    XCTAssertNil(loadedData)
  }

  func test_keychain에_데이터저장후에_삭제_성공() throws {
    // Arrange
    let password = "PaSSwOrd!@#$%QWER"
    let data = try JSONEncoder().encode(password)
    // Act
    sut.save(key: key, data: data)
    let state = sut.delete(key: key)

    // Assert
    XCTAssertEqual(state, noErr)
  }

  func test_keychain에_데이터저장후에_없는_키값으로인한_삭제_실패() throws {
    // Arrange
    let password = "PaSSwOrd!@#$%QWER"
    let data = try JSONEncoder().encode(password)
    let differentKey = "what?"

    // Act
    sut.save(key: differentKey, data: data)
    let state = sut.delete(key: key)

    // Assert
    XCTAssertEqual(state, errSecItemNotFound)
  }
}
