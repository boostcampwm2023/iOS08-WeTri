//
//  SignUpUser.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/7/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - SignUpUser

public struct SignUpUser {
  let provider: String
  let nickName: String
  let gender: String
  let birthDate: String
  let profileImage: URL?
  let mappedUserID: String
}

// MARK: Codable

extension SignUpUser: Codable {
  enum CodingKeys: String, CodingKey {
    case provider
    case nickName = "nickname"
    case gender
    case birthDate = "birthdate"
    case profileImage
    case mappedUserID
  }
}
