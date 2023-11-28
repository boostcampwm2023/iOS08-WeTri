//
//  AuthorizeUseCase.swift
//  LoginFeature
//
//  Created by 안종표 on 11/28/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

final class AuthorizeUseCase: AuthorizeUseCaseRepresentable {
  private let authorizationRepository: AuthorizationRepositoryRepresentable

  init(authorizationRepository: AuthorizationRepositoryRepresentable) {
    self.authorizationRepository = authorizationRepository
  }

  func authorize(authorizationInfo: AuthorizationInfo) -> AnyPublisher<Token, Never> {
    return authorizationRepository.fetch(authorizationInfo: authorizationInfo)
      .eraseToAnyPublisher()
  }
}
