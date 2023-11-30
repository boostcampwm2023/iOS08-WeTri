//
//  LoginCoordinating.swift
//  LoginFeature
//
//  Created by 안종표 on 11/30/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Coordinator
import Foundation

public protocol LoginCoordinating: Coordinating {
  func pushLoginViewController()
}
