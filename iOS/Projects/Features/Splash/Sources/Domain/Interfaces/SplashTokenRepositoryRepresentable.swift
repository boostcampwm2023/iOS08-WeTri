//
//  SplashTokenRepositoryRepresentable.swift
//  SplashFeature
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import Foundation

// MARK: - SplashTokenRepositoryRepresentable

public protocol SplashTokenRepositoryRepresentable {
  func reissueAccessToken() -> AnyPublisher<ReissueAccessTokenDTO, Error>
  func reissueRefreshToken() -> AnyPublisher<ReissueRefreshTokenDTO, Error>
}
