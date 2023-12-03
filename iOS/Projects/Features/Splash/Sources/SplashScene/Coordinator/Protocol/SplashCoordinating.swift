//
//  SplashCoordinating.swift
//  WeTri
//
//  Created by 홍승현 on 12/3/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation

protocol SplashCoordinating: Coordinating {
  func showLoginOrMainFlow(when hasTokenExpired: Bool)
}
