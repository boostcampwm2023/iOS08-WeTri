//
//  AuthorizeUseCase.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

public final class AuthorizeUseCase: AuthorizeUseCaseRepresentable {
  public func authorize(authorization _: AuthorizationInfo) -> AnyPublisher<Token, Never> {
    return Just(Token(accesToken: Data(count: 10), refreshToken: Data(count: 10)))
      .eraseToAnyPublisher()
  }
}
