//
//  UserInformationManagerTest.swift
//  UserInformationManagerTests
//
//  Created by MaraMincho on 12/6/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

@testable import UserInformationManager
import XCTest

final class UserInformationManagerTest: XCTestCase {
  var sut: UserInformationManager!
  override func setUpWithError() throws {
    sut = UserInformationManager.shared
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_가짜_이름을_불러오고_nil이_아님을_확인한다() {
    guard
      let nameData = sut.data(.userName),
      let nameString = String(data: nameData, encoding: .utf8)
    else {
      XCTFail()
      return
    }
    XCTAssertNotNil(nameString)
  }

  func test_가짜_생일을_불러오고_nil이_아님을_확인한다() {
    let dateFormatter = DateFormatter()
    guard
      let birthDate = sut.data(.birthDayDate),
      let birthDateString = String(data: birthDate, encoding: .utf8)
    else {
      XCTFail()
      return
    }
  }

  func test_가짜_프로필이미지를_불러오고_nil이_아님을_확인한다() {
    guard
      let imageData = sut.data(.userProfileImage)
    else {
      XCTFail()
      return
    }
    XCTAssertNotNil(imageData)
  }
}
