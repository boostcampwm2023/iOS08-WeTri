//
//  AuthorizeUseCaseRepresentable.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

protocol AuthorizeUseCaseRepresentable {
  func authorize(authorizationInfo: AuthorizationInfo) -> AnyPublisher<Token, Never>
}
