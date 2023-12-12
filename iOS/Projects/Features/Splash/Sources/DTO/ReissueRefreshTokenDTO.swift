//
//  ReissueRefreshTokenDTO.swift
//  SplashFeature
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - ReissueRefreshTokenDTO

public struct ReissueRefreshTokenDTO: Decodable {
  let refreshToken: String
}
