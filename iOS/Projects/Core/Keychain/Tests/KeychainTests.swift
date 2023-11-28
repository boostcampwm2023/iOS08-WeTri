//
//  KeychainTests.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 11/28/23.
//

@testable import Keychain
import XCTest

final class KeychainTests: XCTestCase {
  var sut: Keychain!
  var key: String!

  override func setUp() {
    sut = Keychain()
    key = "TestKey"
  }

  func test_keychain에_데이터저장_성공() {}
}
