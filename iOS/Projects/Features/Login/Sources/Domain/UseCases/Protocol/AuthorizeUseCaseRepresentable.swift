//
//  AuthorizeUseCaseRepresentable.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Auth
import Combine
import Foundation

protocol AuthorizeUseCaseRepresentable {
  typealias LoginResponse = (token: Token?, initialUser: InitialUser?)

  func authorize(authorizationInfo: AuthorizationInfo) -> AnyPublisher<LoginResponse, Never>
  func accessTokenSave(_ token: String)
  func refreshTokenSave(_ token: String)
}
